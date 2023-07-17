{
  inputs = {
    tilt.url = github:defn/dev/pkg-tilt-0.33.1-2?dir=m/pkg/tilt;
    nomad.url = github:defn/dev/pkg-nomad-1.5.6-4?dir=m/pkg/nomad;
    boundary.url = github:defn/dev/pkg-boundary-0.13.0-2?dir=m/pkg/boundary;
    vault.url = github:defn/dev/pkg-vault-1.14.0-2?dir=m/pkg/vault;
    gh.url = github:defn/dev/pkg-gh-2.32.0-2?dir=m/pkg/gh;
    earthly.url = github:defn/dev/pkg-earthly-0.7.12-1?dir=m/pkg/earthly;
    oras.url = github:defn/dev/pkg-oras-1.0.0-3?dir=m/pkg/oras;
    buildkite.url = github:defn/dev/pkg-buildkite-3.49.0-2?dir=m/pkg/buildkite;
    bk.url = github:defn/dev/pkg-bk-2.0.0-11?dir=m/pkg/bk;
    buildevents.url = github:defn/dev/pkg-buildevents-0.15.0-1?dir=m/pkg/buildevents;
    honeyvent.url = github:defn/dev/pkg-honeyvent-1.1.3-10?dir=m/pkg/honeyvent;
    honeymarker.url = github:defn/dev/pkg-honeymarker-0.2.10-10?dir=m/pkg/honeymarker;
    honeytail.url = github:defn/dev/pkg-honeytail-1.8.3-8?dir=m/pkg/honeytail;
    kuma.url = github:defn/dev/pkg-kuma-2.3.0-2?dir=m/pkg/kuma;
    zola.url = github:defn/dev/pkg-zola-0.0.3?dir=m/pkg/zola;
    hugo.url = github:defn/dev/pkg-hugo-0.0.5?dir=m/pkg/hugo;
  };

  outputs = inputs: inputs.tilt.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = with ctx.pkgs; [
            inputs.tilt.defaultPackage.${ctx.system}
            inputs.nomad.defaultPackage.${ctx.system}
            inputs.boundary.defaultPackage.${ctx.system}
            inputs.vault.defaultPackage.${ctx.system}
            inputs.gh.defaultPackage.${ctx.system}
            inputs.earthly.defaultPackage.${ctx.system}
            inputs.oras.defaultPackage.${ctx.system}
            inputs.buildkite.defaultPackage.${ctx.system}
            inputs.bk.defaultPackage.${ctx.system}
            inputs.buildevents.defaultPackage.${ctx.system}
            inputs.honeyvent.defaultPackage.${ctx.system}
            inputs.honeymarker.defaultPackage.${ctx.system}
            inputs.honeytail.defaultPackage.${ctx.system}
            inputs.kuma.defaultPackage.${ctx.system}
            inputs.zola.defaultPackage.${ctx.system}
            inputs.hugo.defaultPackage.${ctx.system}
            skopeo
          ];
        in
        flakeInputs ++ ctx.commands;
    };

    scripts = { system }: {
      tilt = ''
        port="$(
          (
          ss -tln --tcp --no-header | awk '{print $4}' | cut -d: -f2 | sort
          seq 10300 10399
          ) | sort | uniq -c | perl -ne 'print if m{\b103\d\d\b}' | grep ' 1 ' | awk '{print $2}' | head -1
        )"
        exec tilt up --port "$port" "$@"
      '';
    };
  };
}
