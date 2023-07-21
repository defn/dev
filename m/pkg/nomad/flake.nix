{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/nomad/${input.vendor}/nomad_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 nomad $out/bin/nomad
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
        sha256 = "sha256-5MAcUcOTsmau5P8YTdl3BK49g4wjOmGJQlqfHDGlX08="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Z7KytizuEC90NjkViPZ0QNRHN7dcPSnf6+yUlIkoN00="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-mHGXPHaymvcRW2/D8QPMloqgaAy+Os7/pMo68ljFsqw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9EqBEdVC6p6Sji77zBHEFu0IqGztSN8wZ/9z1W0SDLQ="; # aarch64-darwin
      };
    };
  };
}
