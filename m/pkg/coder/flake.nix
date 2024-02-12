{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-coder"; };

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/coder";
      };
    };

    url_template = input:
      if input.os == "linux" then
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.tar.gz"
      else
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin $out/lib
      cp coder $out/bin/coder
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-hsX/DcnldshzDcbSvbLdRIdQL9zU3XrPPpXBbBUwCGI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Rr6VCVc0mRDOBu7p96T4JwSJ7KOu3wg6vGiMaLHT7DM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-RH7sRIUIZ97raBvzSt2Po6xD1PXhGKx5lFYpjiFFpyo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-jPVKgYhEQgO19jS8TOyf+8JuumFM8bajZZ0K48Ppogk="; # aarch64-darwin
      };
    };
  };
}
