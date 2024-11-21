import { exec } from "child_process";
import { Capability, K8s, Log, RegisterKind, a, kind } from "pepr";

import { components } from "../Script";

import { Client } from "@temporalio/client";

export async function example(name: string): Promise<string> {
  return name;
}

class ScriptKind extends a.GenericKind {
  spec: components["schemas"]["Script"];
}

RegisterKind(ScriptKind, {
  group: "defn.dev",
  version: "v1",
  kind: "Script",
});

export const DefnPepr = new Capability({
  name: "defn",
  description: "Sandbox Operator",
  namespaces: ["defn"],
});

const { When } = DefnPepr;

When(ScriptKind)
  .IsDeleted()
  .Watch(async scr => {
    await K8s(kind.ConfigMap).Delete({
      metadata: {
        name: scr.metadata.name,
        namespace: scr.metadata.namespace,
      },
    });
  });

When(ScriptKind)
  .IsCreatedOrUpdated()
  .Watch(async scr => {
    Log.info("Script workdir: " + scr.spec.workdir);
    Log.info("Script script: " + scr.spec.script);

    exec(scr.spec.script, async (error, stdout, stderr) => {
      if (error) {
        Log.error(`Error executing script: ${error}`);
        return;
      }

      if (stderr) {
        Log.error(`Script error output: ${stderr}`);
        return;
      }

      Log.info(`Script output: ${stdout}`);

      const client = new Client();
      const result = await client.workflow.execute(example, {
        taskQueue: "fetch-esm",
        workflowId: `batch-${process.pid}-${Math.random()}`,
        args: [scr.spec.script],
      });

      await K8s(kind.ConfigMap)
        .Apply({
          metadata: {
            name: scr.metadata.name,
            namespace: scr.metadata.namespace,
          },
          data: {
            result: `From Temporal: ${result}, From Exec: ${stdout}`,
          },
        })
        .then(() => Log.info("WebApp CRD registered"))
        .catch(err => {
          Log.error(err);
        });
    });
  });

When(a.Namespace)
  .IsCreated()
  .WithName("defn")
  .Watch(async ns => {
    Log.info("Namespace defn was created.");

    try {
      await K8s(kind.ConfigMap).Apply({
        metadata: {
          name: "defn",
          namespace: "defn",
        },
        data: {
          "ns-uid": ns.metadata?.uid,
          counter: "1",
        },
      });
    } catch (error) {
      Log.error(error, "Failed to apply ConfigMap using server-side apply.");
    }
  });
