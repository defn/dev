{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kubectl"; };

    url_template = input: "https://dl.k8s.io/release/v${input.vendor}/bin/${input.os}/${input.arch}/kubectl";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kubectl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-1jnto5vi3OQvvsIeA4lCq1c0VBcV4+pfspya12aGvX8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-v8bLcQQevA8EhAKYjszBB8//K4ZshkIxya2gWrMo5b8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-u0yzRrIP20CiD29VxSeXT15fLre895UMVFrG1l8A7q8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-rWGRvKinJVluxnGBwcVBq5Gfh0RO0UntCxzzCiim0b8="; # aarch64-darwin
      };
    };
  };
}
