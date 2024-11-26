{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-temporal"; };

    url_template = input: "https://github.com/temporalio/cli/releases/download/v${input.vendor}/temporal_cli_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 temporal $out/bin/temporal
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-GVUxNQlgE4trWWCOPXzJ4Z78S+5zVhTtuZlydbYA1Ds="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-6uX+BCLW+gOObHOyli0oBU4aImckxIdDWa6EMrRY/a0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-FPicEAV/PFgatwp028BPdW5nuNZed68LCf6xn747T3w="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-PZRfSC0K+ri6gBc4IHcko8PpuJaqDcgtFSRnTzCAuss="; # aarch64-darwin
      };
    };
  };
}
