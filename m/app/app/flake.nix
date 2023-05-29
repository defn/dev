{
  inputs = {
    gomod2nix.url = github:defn/gomod2nix/1.5.0-9;
    godev.url = github:defn/dev/pkg-godev-0.0.82?dir=m/pkg/godev;
    nodedev.url = github:defn/dev/pkg-nodedev-0.0.48?dir=m/pkg/nodedev;
    cloud.url = github:defn/dev/pkg-cloud-0.0.95?dir=m/pkg/cloud;
    kubernetes.url = github:defn/dev/pkg-kubernetes-0.0.99?dir=m/pkg/kubernetes;
    localdev.url = github:defn/dev/pkg-localdev-0.0.125?dir=m/pkg/localdev;
    latest.url = github:NixOS/nixpkgs?rev=64c27498901f104a11df646278c4e5c9f4d642db;
  };

  outputs = inputs:
    let
      pkg = inputs.godev.inputs.goreleaser.inputs.pkg;

      kustomizeMain = caller:
        let
          kustomize = ctx: ctx.wrap.bashBuilder {
            src = caller.src;

            buildInputs = [
              inputs.kubernetes.defaultPackage.${ctx.system}
            ];

            installPhase = ''
              mkdir -p $out
              kustomize build > $out/main.yaml
            '';
          };
        in
        pkg.main rec {
          src = caller.src;

          defaultPackage = ctx: kustomize (ctx // { inherit src; });
        };

      goMain = caller:
        let
          defaultCaller = {
            extendBuild = ctx: { };
            extendShell = ctx: { };
            generateCompletion = "";
          } // caller;

          goShell = ctx: ctx.wrap.nullBuilder ({ } // (defaultCaller.extendShell ctx));

          go = ctx:
            ctx.wrap.bashBuilder (
              let
                gomod2nixOverlay = inputs.gomod2nix.overlays.default;

                goPkgs = import inputs.latest {
                  system = ctx.system;
                  overlays = [ gomod2nixOverlay ];
                };

                goEnv = goPkgs.mkGoEnv {
                  pwd = caller.src;
                };
              in
              {
                src = caller.src;

                buildInputs = [
                  goEnv
                  inputs.godev.defaultPackage.${ctx.system}
                ];

                installPhase = ''
                  mkdir -p $out/bin
                  ls -ltrhd ${ctx.goCmd}/bin/*
                  cp ${ctx.goCmd}/bin/${ctx.config.cli} $out/bin/
                  if [[ -n "${defaultCaller.generateCompletion}" ]]; then
                    mkdir -p $out/share/bash-completion/completions
                    $out/bin/${ctx.config.cli} completion bash > $out/share/bash-completion/completions/_${ctx.config.cli}
                  fi
                '';
              } // (defaultCaller.extendBuild ctx)
            );
        in
        pkg.main rec {
          src = caller.src;

          defaultPackage = ctx:
            let
              gomod2nixOverlay = inputs.gomod2nix.overlays.default;

              goPkgs = import inputs.latest {
                system = ctx.system;
                overlays = [ gomod2nixOverlay ];
              };

              goCmd = goPkgs.buildGoApplication rec {
                inherit src;
                pwd = src;
                pname = ctx.config.slug;
                version = ctx.config.version;
              };
            in
            go (ctx // { inherit src; inherit goCmd; });

          devShell = ctx:
            let
              gomod2nixOverlay = inputs.gomod2nix.overlays.default;

              goPkgs = import inputs.latest {
                system = ctx.system;
                overlays = [ gomod2nixOverlay ];
              };

              goEnv = goPkgs.mkGoEnv {
                pwd = src;
              };
            in
            ctx.wrap.devShell {
              devInputs = ctx.commands ++ [
                goEnv
                goPkgs.gomod2nix
                (goShell ctx)
                inputs.godev.defaultPackage.${ctx.system}
                inputs.nodedev.defaultPackage.${ctx.system}
                inputs.cloud.defaultPackage.${ctx.system}
                inputs.kubernetes.defaultPackage.${ctx.system}
                inputs.localdev.defaultPackage.${ctx.system}
              ];
            };

          scripts = { system }: {
            update = ''
              go get -u ./...
              go mod tidy
              gomod2nix
            '';
          };
        };

      cdktfMain = caller:
        let
          defaultCaller = {
            extendBuild = ctx: { };
            extendShell = ctx: { };
          } // caller;

          cdktfShell = ctx: ctx.wrap.nullBuilder ({ } // (defaultCaller.extendShell ctx));

          cdktf = ctx: ctx.wrap.bashBuilder
            ({
              src = caller.src;

              buildInputs = [
                inputs.nodedev.defaultPackage.${ctx.system}
                inputs.cloud.defaultPackage.${ctx.system}
              ];

              installPhase = ''
                echo 1
                mkdir -p $out
                ${caller.infra.defaultPackage.${ctx.system}}/bin/${caller.infra_cli}
                cp -a cdktf.out/. $out/.
              '';
            }) // (defaultCaller.extendBuild ctx);
        in
        pkg.main rec {
          src = caller.src;

          defaultPackage = ctx: cdktf (ctx // { inherit src; });

          devShell = ctx: ctx.wrap.devShell {
            devInputs = ctx.commands ++ [
              inputs.nodedev.defaultPackage.${ctx.system}
              inputs.cloud.defaultPackage.${ctx.system}
              caller.infra.defaultPackage.${ctx.system}
              (cdktfShell ctx)
            ];
          };
        };
    in
    {
      inherit pkg;
      inherit kustomizeMain;
      inherit goMain;
      inherit cdktfMain;
    } // pkg.main rec {
      src = ./.;
      defaultPackage = ctx: ctx.wrap.nullBuilder {
        propagatedBuildInputs = with ctx.pkgs; [
          bashInteractive
          inputs.godev.defaultPackage.${ctx.system}
          inputs.nodedev.defaultPackage.${ctx.system}
        ];
      };

      packages = ctx: rec {
        devShell = ctx: ctx.wrap.devShell {
          devInputs = [
            (defaultPackage ctx)
          ];
        };
      };
    };
}
