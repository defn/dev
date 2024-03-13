{
  inputs = {
    tilt.url = github:defn/dev/pkg-tilt-0.33.11-1?dir=m/pkg/tilt;
    gh.url = github:defn/dev/pkg-gh-2.45.0-1?dir=m/pkg/gh;
    ghapps.url = github:defn/dev/pkg-ghapps-2.45.0-1?dir=m/pkg/ghapps;
    earthly.url = github:defn/dev/pkg-earthly-0.8.5-1?dir=m/pkg/earthly;
    oras.url = github:defn/dev/pkg-oras-1.1.0-5?dir=m/pkg/oras;
    buildkite.url = github:defn/dev/pkg-buildkite-3.66.0-1?dir=m/pkg/buildkite;
    buildevents.url = github:defn/dev/pkg-buildevents-0.16.0-1?dir=m/pkg/buildevents;
    honeyvent.url = github:defn/dev/pkg-honeyvent-1.1.3-15?dir=m/pkg/honeyvent;
    honeymarker.url = github:defn/dev/pkg-honeymarker-0.2.11-5?dir=m/pkg/honeymarker;
    honeytail.url = github:defn/dev/pkg-honeytail-1.8.3-13?dir=m/pkg/honeytail;
    hugo.url = github:defn/dev/pkg-hugo-0.0.10?dir=m/pkg/hugo;
    vault.url = github:defn/dev/pkg-vault-1.15.6-1?dir=m/pkg/vault;
  };

  outputs = inputs: inputs.tilt.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-localdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = with ctx.pkgs; [
            inputs.tilt.defaultPackage.${ctx.system}
            inputs.gh.defaultPackage.${ctx.system}
            inputs.ghapps.defaultPackage.${ctx.system}
            inputs.earthly.defaultPackage.${ctx.system}
            inputs.oras.defaultPackage.${ctx.system}
            inputs.buildkite.defaultPackage.${ctx.system}
            inputs.buildevents.defaultPackage.${ctx.system}
            inputs.honeyvent.defaultPackage.${ctx.system}
            inputs.honeymarker.defaultPackage.${ctx.system}
            inputs.honeytail.defaultPackage.${ctx.system}
            inputs.hugo.defaultPackage.${ctx.system}
            inputs.vault.defaultPackage.${ctx.system}
            redis
            postgresql
          ];
        in
        flakeInputs;
    };
  };
}
