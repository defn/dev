{
  inputs = {
    tilt.url = github:defn/dev/pkg-tilt-0.33.10-4?dir=m/pkg/tilt;
    gh.url = github:defn/dev/pkg-gh-2.43.1-1?dir=m/pkg/gh;
    earthly.url = github:defn/dev/pkg-earthly-0.8.3-1?dir=m/pkg/earthly;
    oras.url = github:defn/dev/pkg-oras-1.1.0-4?dir=m/pkg/oras;
    buildkite.url = github:defn/dev/pkg-buildkite-3.62.0-1?dir=m/pkg/buildkite;
    buildevents.url = github:defn/dev/pkg-buildevents-0.15.0-5?dir=m/pkg/buildevents;
    honeyvent.url = github:defn/dev/pkg-honeyvent-1.1.3-14?dir=m/pkg/honeyvent;
    honeymarker.url = github:defn/dev/pkg-honeymarker-0.2.11-4?dir=m/pkg/honeymarker;
    honeytail.url = github:defn/dev/pkg-honeytail-1.8.3-12?dir=m/pkg/honeytail;
    hugo.url = github:defn/dev/pkg-hugo-0.0.9?dir=m/pkg/hugo;
  };

  outputs = inputs: inputs.tilt.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-localdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = with ctx.pkgs; [
            inputs.tilt.defaultPackage.${ctx.system}
            inputs.gh.defaultPackage.${ctx.system}
            inputs.earthly.defaultPackage.${ctx.system}
            inputs.oras.defaultPackage.${ctx.system}
            inputs.buildkite.defaultPackage.${ctx.system}
            inputs.buildevents.defaultPackage.${ctx.system}
            inputs.honeyvent.defaultPackage.${ctx.system}
            inputs.honeymarker.defaultPackage.${ctx.system}
            inputs.honeytail.defaultPackage.${ctx.system}
            inputs.hugo.defaultPackage.${ctx.system}
            redis
            postgresql
          ];
        in
        flakeInputs;
    };
  };
}
