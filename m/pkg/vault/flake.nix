{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/vault/${input.vendor}/vault_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 vault $out/bin/vault
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
        sha256 = "sha256-YDFDLfw94H9lI9IGxE/AGKqWnZTI6RJadzQK81n1fqM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-GrYlKwTN5dI4+9N/FsK+RYUWmIYAKrUBmP4NmivycP4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NUIuUnaVe8rEAR/RbjmpmwaNdGquf/tZRIo/wNv3Owg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-YSARE4g2cqkUKCyjTKxlnF66ZQqqXmztu8RP1dDjGkU="; # aarch64-darwin
      };
    };
  };
}
