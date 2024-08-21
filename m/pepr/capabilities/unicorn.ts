import { Capability, Log, RegisterKind, a } from "pepr";

import { components } from "../unicorns";

class UnicornKind extends a.GenericKind {
  spec: components["schemas"]["Unicorn"];
}

RegisterKind(UnicornKind, {
  group: "pepr.dev",
  version: "v1",
  kind: "Unicorn",
});

export const UnicornPepr = new Capability({
  name: "unicorn",
  description: "A simple example capability to show how custom resources work.",
  namespaces: ["defn"],
});

const { When } = UnicornPepr;

RegisterKind(UnicornKind, {
  group: "pepr.dev",
  version: "v1",
  kind: "Unicorn",
});

When(UnicornKind)
  .IsCreated()
  .Mutate(request => {
    request.Merge({
      spec: {
        message: "Hello Pepr with type data!",
        counter: Math.random(),
      },
    });
  })
  .Watch(async uni => {
    Log.info("Unicorn mutated: " + uni.metadata.name);
  });
