{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-LW7/AEhkzCcNzQ+VdXnDKgO3z7TdepwjdH97BobVEcA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-iGZCPFck+WYYpKp/bP4k+ev7JVPxLfFGy4+alCbJkMw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-wo/7NPPqwLOMiRBajGcPJBBbNpgSTNnn6nBvl+sH6d0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VxlmRchwGjOZxeTUxx7uHzL1iLg28g6m9rPHZa6uoQE="; # aarch64-darwin
      };
    };
  };
}
