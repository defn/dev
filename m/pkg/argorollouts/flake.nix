{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-rollouts/releases/download/v${input.vendor}/kubectl-argo-rollouts-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argo-rollouts
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-zTHpWM5NUVPOPOLUrd3jso0R7Ia3lqLMRB/i0n0kf/o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-eNZvLH7UOUJ4zNu7mL6bRPuOF3+BMJ2nVwY4XUL9PgA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-oifthcXIKFzdZLwKpOcN9Og9pf7j/PGHhL4LMB+rTaI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ua+PCPvH2fPGEQ3D1sQs9y+1WizyT7y5isQK36r1bb0="; # aarch64-darwin
      };
    };
  };
}
