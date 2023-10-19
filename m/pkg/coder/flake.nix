{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-awB760bT8X1E4RCqvdEcO5p8uE5PWPWzPzXlcq4Yk3E="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ar29CtdyF2HfDYrTgW+wyJ5n7d750TMRcOESI0fnwAI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-GKYmcwvJNGbpO4YwaSXQMVVInvlTO3NnvaRvpshYRsc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-at7odWXcj8c8kEKMK7Z6q4h30PYDdvkCD4xS8X3Y3cc="; # aarch64-darwin
      };
    };
  };
}
