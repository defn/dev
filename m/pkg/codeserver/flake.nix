{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-codeserver"; };

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/code-server";
      };
    };

    url_template = input:
      if input.os == "macos" && input.arch == "amd64" then
        "https://github.com/coder/code-server/releases/download/v${input.vendor2}/code-server-${input.vendor2}-${input.os}-${input.arch}.tar.gz"
      else
        "https://github.com/coder/code-server/releases/download/v${input.vendor}/code-server-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg:
      if pkg.config.os == "macos" && pkg.config.arch == "amd64" then
        ''
          install -m 0755 -d $out $out/bin $out/lib
          rsync -ia . $out/lib/.
          mv -f $out/lib/code-server-${pkg.config.vendor2}-*  $out/lib/code-server-${pkg.config.vendor2}
          ln -fs $out/lib/code-server-${pkg.config.vendor2}/bin/code-server $out/bin/code-server
          ln -fs $out/lib/code-server-${pkg.config.vendor2}/lib/vscode/bin/helpers/browser.sh $out/bin/browser.sh
          ln -fs $out/lib/code-server-${pkg.config.vendor2}/lib/vscode/bin/remote-cli/code-server $out/bin/remote-code-server
        ''
      else
        ''
          install -m 0755 -d $out $out/bin $out/lib
          rsync -ia . $out/lib/.
          mv -f $out/lib/code-server-${pkg.config.vendor}-*  $out/lib/code-server-${pkg.config.vendor}
          ln -fs $out/lib/code-server-${pkg.config.vendor}/bin/code-server $out/bin/code-server
          ln -fs $out/lib/code-server-${pkg.config.vendor}/lib/vscode/bin/helpers/browser.sh $out/bin/browser.sh
        '';

    downloads = {
      options = pkg: {
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ rsync ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-zb4L9qgEB9Qfq0HT0MyYGG7597yg91AEGbXtklnb8z8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-C7HaJ/pmXeLlkUWlizfIRL4+j/W1wsAResDr58kAOsY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "amd64";
        sha256 = "sha256-FS47wofOxhh6gyw5cOF90gFnFQHKJra0g1Wg4Q4SdrY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-bopJ7WpYid3sGc3yd6AizO5ydUBqQuj3eyFxHX5kyKk="; # aarch64-darwin
      };
    };
  };
}
