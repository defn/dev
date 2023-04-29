{
  inputs = {
    tilt.url = github:devn/dev/pkg-tilt-0.32.2-1?dir=m/pkg/tilt;
    nomad.url = github:devn/dev/pkg-nomad-1.5.3-7?dir=m/pkg/nomad;
    boundary.url = github:devn/dev/pkg-boundary-0.12.2-6?dir=m/pkg/boundary;
    vault.url = github:devn/dev/pkg-vault-1.13.2-1?dir=m/pkg/vault;
    gh.url = github:devn/dev/pkg-gh-2.27.0-6?dir=m/pkg/gh;
    earthly.url = github:devn/dev/pkg-earthly-0.7.4-4?dir=m/pkg/earthly;
    buildkite.url = github:devn/dev/pkg-buildkite-3.45.0-6?dir=m/pkg/buildkite;
    bk.url = github:devn/dev/pkg-bk-2.0.0-7?dir=m/pkg/bk;
    buildevents.url = github:devn/dev/pkg-buildevents-0.13.0-6?dir=m/pkg/buildevents;
    honeyvent.url = github:devn/dev/pkg-honeyvent-1.1.3-6?dir=m/pkg/honeyvent;
    honeymarker.url = github:devn/dev/pkg-honeymarker-0.2.10-6?dir=m/pkg/honeymarker;
    honeytail.url = github:devn/dev/pkg-honeytail-1.8.3-4?dir=m/pkg/honeytail;
    kuma.url = github:devn/dev/pkg-kuma-2.2.0-1?dir=m/pkg/kuma;
  };

  outputs = inputs: inputs.tilt.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.tilt.defaultPackage.${ctx.system}
            inputs.nomad.defaultPackage.${ctx.system}
            inputs.boundary.defaultPackage.${ctx.system}
            inputs.vault.defaultPackage.${ctx.system}
            inputs.gh.defaultPackage.${ctx.system}
            inputs.earthly.defaultPackage.${ctx.system}
            inputs.buildkite.defaultPackage.${ctx.system}
            inputs.bk.defaultPackage.${ctx.system}
            inputs.buildevents.defaultPackage.${ctx.system}
            inputs.honeyvent.defaultPackage.${ctx.system}
            inputs.honeymarker.defaultPackage.${ctx.system}
            inputs.honeytail.defaultPackage.${ctx.system}
            inputs.kuma.defaultPackage.${ctx.system}
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
