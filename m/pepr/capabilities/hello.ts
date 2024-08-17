import {
  Capability,
  K8s,
  Log,
  PeprMutateRequest,
  RegisterKind,
  a,
  fetch,
  fetchStatus,
  kind,
} from "pepr";

export const HelloPepr = new Capability({
  name: "hello",
  description: "A simple example capability to show how things work.",
  namespaces: ["defn"],
});

const { When, Store } = HelloPepr;

class UnicornKind extends a.GenericKind {
  spec: {
    message: string;
    counter: number;
  };
}

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
  });
