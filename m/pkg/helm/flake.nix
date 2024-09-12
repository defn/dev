{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-helm"; };

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Mnz7x93Fo+tkQDnOsM/2Y5RihlTE9adr9xXtFbiTmDs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/BIVkLUy1/IDeuXN050rVt7JYGnYvGE6CJZfKaFW6E8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Vl4ZYt+RCvxJTKGt6CZDqIHuPLxedX7gDfo21G1nMCU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ea92LcXe1U+OMha/jSR4AYI8Y+xKzR0MmpWK842ymcY="; # aarch64-darwin
      };
    };
  };
}
