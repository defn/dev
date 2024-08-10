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
  namespaces: ["pepr-demo", "pepr-demo-2"],
});

const { When, Store } = HelloPepr;

Store.onReady(data => {
  Log.info(data, "Pepr Store Ready");
});

// when any ns is created:
// remove "remove-me" labelfrom namespace
When(a.Namespace)
  .IsCreated()
  .Mutate(ns => ns.RemoveLabel("remove-me"));

// when ns pepr-demo-2 is created:
// add a configmap pepr-ssa-demo
When(a.Namespace)
  .IsCreated()
  .WithName("pepr-demo-2")
  .Watch(async ns => {
    Log.info("Namespace pepr-demo-2 was created.");

    try {
      await K8s(kind.ConfigMap).Apply({
        metadata: {
          name: "pepr-ssa-demo",
          namespace: "pepr-demo-2",
        },
        data: {
          "ns-uid": ns.metadata.uid,
        },
      });
    } catch (error) {
      Log.error(error, "Failed to apply ConfigMap using server-side apply.");
    }

    Store.setItem("watch-data", "This data was stored by a Watch Action.");
  });

// when cm example-1 created:
// set label pepr = was-here
// set annotaton pepr.dev = annotations-work-too
When(a.ConfigMap)
  .IsCreated()
  .WithName("example-1")
  .Mutate(request => {
    request
      .SetLabel("pepr", "was-here")
      .SetAnnotation("pepr.dev", "annotations-work-too");

    Store.setItem("example-1", "was-here");
    Store.setItem("example-1-data", JSON.stringify(request.Raw.data));
  });

// when cm example-2 created:
// merge label pepr=was-here, annotation pepr-dev: annotations-work-too
// validate label
When(a.ConfigMap)
  .IsCreated()
  .WithName("example-2")
  .Mutate(request => {
    request.Merge({
      metadata: {
        labels: {
          pepr: "was-here",
        },
        annotations: {
          "pepr.dev": "annotations-work-too",
        },
      },
    });
  })
  .Validate(request => {
    if (request.HasLabel("pepr")) {
      return request.Approve();
    }

    return request.Deny("ConfigMap must have label 'pepr'");
  })
  .Watch((cm, phase) => {
    Log.info(cm, `ConfigMap was ${phase} with the name example-2`);
  });

// when vm is created:
// validate annotation evil= is not present
When(a.ConfigMap)
  .IsCreated()
  .Validate(request => {
    if (request.HasAnnotation("evil")) {
      return request.Deny("No evil CM annotations allowed.", 400);
    }

    return request.Approve();
  });

// when vm is upserted with label change=by-label
// mutate data username=, uid=
// mutate annotation pepr.dev=making-waves
When(a.ConfigMap)
  .IsCreatedOrUpdated()
  .WithLabel("change", "by-label")
  .Mutate(request => {
    const cm = request.Raw;

    const { username, uid } = request.Request.userInfo;

    cm.data["username"] = username;
    cm.data["uid"] = uid;

    request.SetAnnotation("pepr.dev", "making-waves");
  });

// detect when a cm with label change=by-label has been deleted
When(a.ConfigMap)
  .IsDeleted()
  .WithLabel("change", "by-label")
  .Validate(request => {
    Log.info("CM with label 'change=by-label' was deleted.");
    return request.Approve();
  });

// when a cm is created named example-4
// mutate with a function
function example4Cb(cm: PeprMutateRequest<a.ConfigMap>) {
  cm.SetLabel("pepr.dev/first", "true");
  cm.SetLabel("pepr.dev/second", "true");
  cm.SetLabel("pepr.dev/third", "true");
}

When(a.ConfigMap).IsCreated().WithName("example-4").Mutate(example4Cb);

When(a.ConfigMap)
  .IsCreated()
  .InNamespace("pepr-demo-2")
  .WithName("example-4a")
  .Mutate(example4Cb);

/**
 * This action is a bit more complex. It will look for any ConfigMap in the `pepr-demo`
 * namespace that has the label `chuck-norris` during CREATE. When it finds one, it will fetch a
 * random Chuck Norris joke from the API and add it to the ConfigMap. This is a great example of how
 * you can use Pepr to make changes to your K8s objects based on external data.
 *
 * These are equivalent:
 *
 * const joke = await fetch<TheChuckNorrisJoke>("https://icanhazdadjoke.com/");
 * const joke = await fetch("https://icanhazdadjoke.com/") as TheChuckNorrisJoke;
 */
interface TheChuckNorrisJoke {
  id: string;
  joke: string;
  status: number;
}

When(a.ConfigMap)
  .IsCreated()
  .WithLabel("chuck-norris")
  .Mutate(async change => {
    const response = await fetch<TheChuckNorrisJoke>(
      "https://icanhazdadjoke.com/",
      {
        headers: {
          Accept: "application/json",
        },
      },
    );

    if (response.ok) {
      change.Raw.data["chuck-says"] = response.data.joke;
      return;
    }

    if (response.status === fetchStatus.NOT_FOUND) {
      return;
    }
  });

/**
 * The K8s JS client provides incomplete support for base64 encoding/decoding handling for secrets,
 * unlike the GO client. To make this less painful, Pepr automatically handles base64 encoding/decoding
 * secret data before and after the action is executed.
 */
When(a.Secret)
  .IsCreated()
  .WithName("secret-1")
  .Mutate(request => {
    const secret = request.Raw;

    secret.data.magic = "change-without-encoding";
    secret.data.example += " - modified by Pepr";
  });

/**
 * Out of the box, Pepr supports all the standard Kubernetes objects. However, you can also create
 * your own types. This is useful if you are working with an Operator that creates custom resources.
 * There are two ways to do this, the first is to use the `When()` function with a `GenericKind`,
 * the second is to create a new class that extends `GenericKind` and use the `RegisterKind()` function.
 *
 * This example shows how to use the `When()` function with a `GenericKind`. Note that you
 * must specify the `group`, `version`, and `kind` of the object (if applicable). This is how Pepr knows
 * if the action should be triggered or not. Since we are using a `GenericKind`,
 * Pepr will not be able to provide any intellisense for the object, so you will need to refer to the
 * Kubernetes API documentation for the object you are working with.
 */
When(a.GenericKind, {
  group: "pepr.dev",
  version: "v1",
  kind: "Unicorn",
})
  .IsCreated()
  .WithName("example-1")
  .Mutate(request => {
    request.Merge({
      spec: {
        message: "Hello Pepr without type data!",
        counter: Math.random(),
      },
    });
  });

/**
 * This example shows how to use the `RegisterKind()` function to create a new type. This is useful
 * if you are working with an Operator that creates custom resources and you want to have intellisense
 * for the object. Note that you must specify the `group`, `version`, and `kind` of the object (if applicable)
 * as this is how Pepr knows if the action should be triggered or not.
 *
 * Once you register a new Kind with Pepr, you can use the `When()` function with the new Kind. Ideally,
 * you should register custom Kinds at the top of your Capability file or Pepr Module so they are available
 * to all actions, but we are putting it here for demonstration purposes.
 */
class UnicornKind extends a.GenericKind {
  spec: {
    /**
     * @example
     * ```ts
     * request.Raw.spec.message = "Hello Pepr!";
     * ```
     * */
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
  .WithName("example-2")
  .Mutate(request => {
    request.Merge({
      spec: {
        message: "Hello Pepr with type data!",
        counter: Math.random(),
      },
    });
  });
