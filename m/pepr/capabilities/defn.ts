import { exec } from "child_process";
import { Capability, K8s, Log, RegisterKind, a, kind } from "pepr";

import { components } from "../Script";

import { Client } from "@temporalio/client";

export async function greetHTTP(name: string): Promise<string> {
  return `Hello, ${name}!`;
}

export async function example(name: string): Promise<string> {
  return await greetHTTP(name);
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
  .IsCreatedOrUpdated()
  .Watch(async scr => {
    Log.info("Script workdir: " + scr.spec.workdir);
    Log.info("Script script: " + scr.spec.script);

    let output = "";
    exec(scr.spec.script, (error, stdout, stderr) => {
      if (error) {
        Log.error(`Error executing script: ${error}`);
        return;
      }

      if (stderr) {
        Log.error(`Script error output: ${stderr}`);
        return;
      }

      Log.info(`Script output: ${stdout}`);

      output = stdout;
    });

    const client = new Client();
    const result = await client.workflow.execute(example, {
      taskQueue: "fetch-esm",
      workflowId: `batch-${process.pid}`,
      args: [`Temporal: ${scr.spec.script}`],
    });

    try {
      await K8s(ScriptKind).Apply({
        metadata: {
          name: scr.metadata.name,
          namespace: scr.metadata.namespace,
          annotations: {
            results: `From Temporal: ${result}, From Output: ${output}`,
          },
        },
      });
    } catch (error) {
      Log.error(
        error,
        `Failed to apply ConfigMap using server-side apply: ${error}`,
      );
    }
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
