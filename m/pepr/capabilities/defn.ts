import { Capability, K8s, Log, a, kind } from "pepr";

export const DefnPepr = new Capability({
  name: "defn",
  description: "Sandbox Operator",
  namespaces: ["defn"],
});

const { When, Store } = DefnPepr;

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
