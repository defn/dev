{
  inputs.dev.url = github:defn/dev/pkg-dev-0.0.11?dir=m/pkg/dev;
  outputs = inputs:
    let
      main = clr:
        let
          caller = inputs.dev.defaultConfig {
            src = clr.src;
            config = clr;
          };

          json = builtins.fromJSON (builtins.readFile "${caller.src}/flake.json");

          src = builtins.path { path = caller.src; name = json.slug; };

          config = caller // json // { inherit src; };
        in
        inputs.dev.main rec {
          inherit inputs;
          inherit src;
          inherit config;

          scripts =
            if builtins.hasAttr "scripts" caller
            then caller.scripts
            else (ctx: { });

          handler = ctx:
            let
              defaultpackage = caller.defaultPackage ctx;
              devshell =
                if builtins.hasAttr "devShell" caller
                then caller.devShell ctx
                else
                  ctx.wrap.devShell {
                    devInputs = [ defaultpackage ];
                  };
              apps =
                if builtins.hasAttr "apps" caller
                then caller.apps ctx
                else { };
              packages =
                if builtins.hasAttr "packages " caller
                then caller.packages ctx
                else { };
              this = {
                inherit apps;
                inherit packages;
                defaultPackage = defaultpackage;
                devShell = devshell;
              };
              extend =
                if builtins.hasAttr "extend" caller
                then caller.extend (ctx // { inherit this; })
                else { };
            in
            this // extend;
        };

      downloadMain = clr:
        let
          caller = inputs.dev.defaultConfig {
            src = clr.src;
            config = clr;
          };

          src = builtins.path { path = caller.src; name = (builtins.fromJSON (builtins.readFile "${caller.src}/flake.json")).slug; };

          config = caller // { inherit src; };
        in
        inputs.dev.main rec {
          inherit inputs;
          inherit src;
          inherit config;

          handler = ctx:
            let
              options =
                if builtins.hasAttr "options" caller.downloads
                then caller.downloads.options { inherit ctx; }
                else { };
              downloads = ctx.wrap.genDownloadBuilders ({ inherit config; } // options);
              devshell = ctx.wrap.devShell {
                devInputs = [ downloads.defaultPackage ];
              };
              this = downloads // { devShell = devshell; } // extend;
              extend =
                if builtins.hasAttr "extend" caller
                then caller.extend { inherit ctx; inherit this; }
                else { };
            in
            this // extend;
        };
    in
    {
      inherit main;
      inherit downloadMain;
    } // main rec {
      src = builtins.path { path = ./.; name = "pkg-pkg"; };
      defaultPackage = ctx: ctx.wrap.nullBuilder { };
    };
}
