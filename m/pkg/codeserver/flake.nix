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
      if input.os == "macos" && input.arch == "amd64" then
        ''
          install -m 0755 -d $out $out/bin $out/lib
          rsync -ia . $out/lib/.
          mv -f $out/lib/code-server-${pkg.config.vendor2}-*  $out/lib/code-server-${pkg.config.vendor2}
          ln -fs $out/lib/code-server-${pkg.config.vendor2}/bin/code-server $out/bin/code-server
          ln -fs $out/lib/code-server-${pkg.config.vendor2}/lib/vscode/bin/helpers/browser.sh $out/bin/browser.sh
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
        sha256 = "sha256-XDdpsatcuy7OsJJSTcRvVYkF5CYBVbR306MT+eolyjM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-adPR9xWNbiElvS+DFhGrlZoqqA1afZZCKkQHDrK4ZFs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "amd64";
        sha256 = "sha256-FS47wofOxhh6gyw5cOF90gFnFQHKJra0g1Wg4Q4SdrY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-ZW/iYUxQlmBvUo7Fs99r4VbSyCdLES+9ZZW7TXtXfuo="; # aarch64-darwin
      };
    };
  };
}
