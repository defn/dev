{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-kustomize"; };

    url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.vendor}/kustomize_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kustomize $out/bin/kustomize
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ZwOjpwoMR88LN2lAMLVPEXWp3+sXs4GLYj7Vi528Knc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-tBcNGsuM+srOn3KIS++Vf/Vu/c1IE7ZudgSqvItX6T0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-h0Ik51IpghseVxrvpFcDeJt3M2MCo0aS6sZa2+DcHO4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-W6pAe9ruUbl2Ju8fyjKS4aHIRjV9MCjbgmBX7M7tcXg="; # aarch64-darwin
      };
    };
  };
}
