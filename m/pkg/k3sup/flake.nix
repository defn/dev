{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-k3sup"; };

    url_template = input: "https://github.com/alexellis/k3sup/releases/download/${input.vendor}/k3sup${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3sup
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "";
        arch = "";
        sha256 = "sha256-nh8Td4Cvoww0Q16Zn8uozknFLqb+1tSWfUZ8oN6budc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-b56463pmbTJNg7IIH0sO6CdfgxxYiBLzTp2r/Hki7hY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-adPel8Eu+BRJw+2rV6u0OPeaRHYR8Ucylrw8XLxAcZs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-OF2cpJ0W8Mpb9/clFhf7yrLN65uQ2D7oad45c50GjBs="; # aarch64-darwin
      };
    };
  };
}
