import { exec } from "child_process";
import { Capability, K8s, Log, RegisterKind, a, kind } from "pepr";

import { components } from '../defn';

export const DefnPepr = new Capability({
  name: "defn",
  description: "Sandbox Operator",
  namespaces: ["defn"],
});

const { When, Store } = DefnPepr;

class ScriptKind extends a.GenericKind {
  spec: components['schemas']['Script'];
}



RegisterKind(ScriptKind, {
  group: "defn.dev",
  version: "v1",
  kind: "Script",
});

When(ScriptKind)
  .IsCreatedOrUpdated()
  .Watch(async scr => {
    Log.info("Script workdir: " + scr.spec.workdir);
    Log.info("Script created: " + scr.spec.script);
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

    Store.setItem("hello", "world");
  });
