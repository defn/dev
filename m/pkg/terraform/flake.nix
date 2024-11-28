{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-terraform"; };

    url_template = input: "https://releases.hashicorp.com/terraform/${input.vendor}/terraform_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 terraform $out/bin/terraform
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-SwX0hI02VZfPesW1kzTGKhazu3tSRYZXjuRbqCO2dYs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-4S+tNXvP+VN+kEp4IVKSBsLI+0j3ALZwwl1t7du2XQU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-JjwqY91uEbT10GImL/jL+PrVZGCvaeVJPyL0lbNcSrU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Ha7dJROINnVvs+tc8ahatZ0G84Wk47O+vYFRGFvepcs="; # aarch64-darwin
      };
    };
  };
}
