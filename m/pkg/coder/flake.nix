{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/coder";
      };
    };

    url_template = input:
      if input.os == "linux" then
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.tar.gz"
      else
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin $out/lib
      cp coder $out/bin/coder
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-3eH8RmibTpwBom+Vm73B363uCSXZt+0nCcuK5ZHWeB8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-wFbsgELw7EufjvuAr1pFIleJOJh4PQnDv2dlpMuKwi8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-pWkjBcYLrXoglCES2iF/6vFhs7bt7mP2FVrOoCKM0WU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-1PY5+iykW/3JPA/oh2ew/v+N+bpLSa0k4YFRwEaGtqw="; # aarch64-darwin
      };
    };
  };
}
