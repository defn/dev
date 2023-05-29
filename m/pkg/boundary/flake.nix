{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/boundary/${input.vendor}/boundary_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 boundary $out/bin/boundary
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
        sha256 = "sha256-fD2ycRHYYiBhsfxmerSxuw1q8E+KiuPg9t/VjfsIbUE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-CKfWVYdNgoQo6MCnruxrNOo3uM/Hvf8FBiECsBP/9Y4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-FBeOt4EVGY8rDvNJ1Vw+BlVgJKnAxs82T46o64YC5do="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-g84P7ICvMQqoYb5gpzitxkyS4iSsyfRaAik/zs0iyCo="; # aarch64-darwin
      };
    };
  };
}
