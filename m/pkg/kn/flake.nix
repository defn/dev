{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/knative/client/releases/download/knative-v${input.vendor}/kn-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kn
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-4mSftEWE4PtyQtsS4/Lq6R7nJoJRiab9xFK4s+qgn/g="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SntvRbwyPP1Y/8JwAIcGBdE1E0pAHKTlbLDIBcbMBaI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-i2lVDs0Q5x+M4rP8xHfld5ZfFqOJwY0o5czJ3cuZcLU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Os1bZ0GMghc2HYeHunA0Q5fzMnpS2hb8a6YBzquu6mk="; # aarch64-darwin
      };
    };
  };
}
