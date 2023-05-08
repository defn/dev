{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
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
        sha256 = "sha256-4f7D546KNeVp2qpICWicymjbIlNLQd6F2oH+tpRIRwU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DWzjPboRseWAadgBJR9zd8TXzZAlakv8/ZBqdPlFLmk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-KolykE/+jFjPkzocD/7luCk059NLl2zPwIIvKMZgVro="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wwLsQe2dwPumVnSMoP8BXpf1mGTPqthL2wrutUAU0C8="; # aarch64-darwin
      };
    };
  };
}
