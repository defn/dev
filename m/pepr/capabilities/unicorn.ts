import { Capability, Log, RegisterKind, a } from "pepr";

import { components } from "../Unicorn";

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

When(UnicornKind)
  .IsCreatedOrUpdated()
  .Mutate(request => {
    request.Merge({
      spec: {
        message: "Hello Pepr with type data!",
        counter: Math.random(),
      },
    });
    Log.info("Unicorn mutated: " + request.Request.name);
  })
  .Watch(async uni => {
    Log.info("Unicorn seen: " + uni.metadata.name);
  });
