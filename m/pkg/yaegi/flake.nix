{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/traefik/yaegi/releases/download/v${input.vendor}/yaegi_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Y5rnr5G/L/MVPzqb1fVIa8rA7beMVsnBov2UW2RzztI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-GaUsQNBxkI9zg9BqBbNqfj2AEqVvk3BswNOkEKYqP98="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-+e7Hi1bunERr7GcH2TpjPcAeWSODrh7Px6KP9XH1Q1E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-F/+pAE20NKdXUSuObH2145yM6UBASZ+OjQ1lmsUFtzY="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 yaegi $out/bin/yaegi
    '';
  };
}
