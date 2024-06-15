{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?rev=005617587ee2b7c003388b4539b9120ebcc90e44;
  };

  outputs = inputs:
    let
      prelude = rec {
        wrapper = {
          wrap = { other, system, site }:
            let
              pkgs = import inputs.nixpkgs { inherit system; };
              hasDefaultPackage = (item: acc:
                acc ++
                (
                  if item ? ${"slug"}
                  then
                    (
                      (if item.slug.${system} == site.slug
                      then [ ]
                      else
                        (if item ? ${"defaultPackage"}
                        then [ item.defaultPackage.${system} ]
                        else [ ]))
                    )
                  else
                    (
                      if item ? ${"defaultPackage"}
                      then [ item.defaultPackage.${system} ]
                      else [ ]
                    )
                ));
            in
            rec {
              devShell = { devInputs ? [ ] }:
                pkgs.stdenvNoCC.mkDerivation {
                  name = "${site.slug}-shell-${site.version}";
                  buildInputs =
                    [ other.self.defaultPackage.${system} ]
                    ++ devInputs;

                  venvDir = "./.venv";

                  postVenvCreation = ''
                    unset SOURCE_DATE_EPOCH
                    pip install -r requirements.txt
                  '';

                  postShellHook = ''
                    export MEH_LD_LIBRARY_PATH="${lib.makeLibraryPath [glibc zlib gcc.cc]}"
                  '';
                };

              genDownloadBuilders = commonBuild: {
                defaultPackage = downloadBuilder commonBuild;

                packages = pkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ]
                  (name: downloadBuilder (commonBuild // {
                    overrideSystem = name;
                  }));
              };

              downloadBuilder = { propagatedBuildInputs ? [ ], buildInputs ? [ ], dontUnpack ? false, dontFixup ? false, overrideSystem ? system, config }:
                pkgs.stdenv.mkDerivation rec {
                  inherit dontUnpack;
                  inherit dontFixup;

                  inherit propagatedBuildInputs;
                  inherit buildInputs;

                  name = "${site.slug}-${site.version}";

                  src = with site.downloads.${overrideSystem}; pkgs.fetchurl {
                    url = site.url_template (config // site.downloads.${overrideSystem});
                    inherit sha256;
                  };

                  sourceRoot = ".";

                  installPhase = site.installPhase { inherit src; config = (config // site.downloads.${overrideSystem}); };
                };

              bashBuilder = input@{ propagatedBuildInputs ? [ ], buildInputs ? [ ], src, installPhase, dontUnpack ? false, dontFixup ? false, slug ? "${site.slug}" }:
                pkgs.stdenv.mkDerivation rec {
                  name = "${slug}-${site.version}";

                  inherit dontUnpack;
                  inherit dontFixup;

                  inherit propagatedBuildInputs;
                  inherit buildInputs;

                  src = input.src;
                  installPhase = input.installPhase;
                };

              nullBuilder = input@{ propagatedBuildInputs ? [ ], buildInputs ? [ ], dontUnpack ? false, dontFixup ? false, slug ? "null-builder" }:
                bashBuilder rec {
                  inherit dontUnpack;
                  inherit dontFixup;

                  inherit propagatedBuildInputs;
                  inherit buildInputs;

                  src = builtins.path { path = ./.; name = slug; };

                  installPhase = "mkdir -p $out";
                };

              venvBuilder = input@{ propagatedBuildInputs ? [ ], buildInputs ? [ ], dontUnpack ? false, dontFixup ? false, slug ? "null-builder" }:
                bashBuilder rec {
                  inherit dontUnpack;
                  inherit dontFixup;

                  inherit propagatedBuildInputs;
                  inherit buildInputs;

                  devInputs = with ctx.pkgs; [
                    python3Packages.python
                    python3Packages.venvShellHook
                    python3Packages.numpy
                  ];

                  src = builtins.path { path = ./.; name = slug; };

                  installPhase = "mkdir -p $out";
                };
            };
        };

        defaultSystems = [
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
          "x86_64-linux"
        ];

        eachSystem = systems: f:
          let
            op = attrs: system:
              let
                ret = f system;
                op = attrs: key: attrs //
                  {
                    ${key} = (attrs.${key} or { })
                      // { ${system} = ret.${key}; };
                  }
                ;
              in
              builtins.foldl' op attrs (builtins.attrNames ret);
          in
          builtins.foldl' op { } systems
        ;

        eachDefaultSystem = eachSystem defaultSystems;

        dev-inputs = inputs;

        pkgs = dev-inputs.nixpkgs;

        defaultConfig = { src, config ? { } }: (
          if pkgs.lib.hasAttr "vendor" (builtins.fromJSON (builtins.readFile (src + "/flake.json"))) then rec {
            vendor = (builtins.fromJSON (builtins.readFile (src + "/flake.json"))).vendor;
            revision = (builtins.fromJSON (builtins.readFile (src + "/flake.json"))).revision;
            version = "${vendor}-${revision}";
          }
          else rec { }
        ) // config // (builtins.fromJSON (builtins.readFile (src + "/flake.json")));

        main =
          { src
          , inputs
          , config
          , handler
          , scripts ? ({ system }: { })
          , prefix ? "this-"
          }: eachDefaultSystem (system:
          let
            pkgs = import dev-inputs.nixpkgs {
              inherit system;
              overlays = [ ];
            };

            cfg = config;

            commands = pkgs.lib.attrsets.mapAttrsToList
              (name: value: value)
              (
                pkgs.lib.attrsets.mapAttrs
                  (name: value:
                    (pkgs.writeShellScriptBin "${prefix}${name}" value))
                  (scripts { inherit system; })
              );

            wrap = wrapper.wrap {
              other = inputs; inherit system; site = cfg;
            };

            defaults = {
              slug = cfg.slug;
              devShell = wrap.devShell {
                devInputs = commands ++ [ pkgs.bashInteractive ];
              };
            };

            handled = handler {
              inherit pkgs;
              inherit wrap;
              inherit system;
              inherit commands;

              config = cfg;
            };
          in
          defaults // handled
          );
      };
    in
    prelude // (prelude.main rec {
      inherit inputs;

      src = builtins.path { path = ./.; name = "pkg-dev"; };

      config = prelude.defaultConfig { inherit src; };

      prefix = "c-";

      handler = { pkgs, wrap, system, commands, config }: {
        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = commands;
        };
      };
    });
}
