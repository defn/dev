{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-wireproxy"; };

    url_template = input: "https://github.com/pufferffish/wireproxy/releases/download/v${input.vendor}/wireproxy_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 wireproxy $out/bin/wireproxy
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-s5qsxesSfatm0cy7y+6e5s9lnSfr6c7GPElAdUrKt9o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Ssrc1OdKQLt5jSB7PSW0tfQ8/dw5+b63j+W630KLR6Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-2UmbX+tZuCDAuWENqURV4e+W6gGOFwJh/6vt2jkETM4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-lpoK1kydmfIdjoqCAfoZsL46dX0iDolJKk0vUy7q4SY="; # aarch64-darwin
      };
    };
  };
}
