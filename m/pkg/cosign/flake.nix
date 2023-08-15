{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/sigstore/cosign/releases/download/v${input.vendor}/cosign-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cosign
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
        sha256 = "sha256-hKhZ+2VOLCwMvGQzqBlf72C8zRa0z0EvSGwsZ9S5EkE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VjrkwvA91wqbkOQFjN8Us+M6p32dxiduy5dHNRPCOPg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-W3tNt9vXwZzonSSkhGJ9yW+t0mMrAz/pofgAXCnb6E4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-QzmgrwBZ3cSnr3whjcqqFJaUhWP1kVp3c6rbCFp+6g4="; # aarch64-darwin
      };
    };
  };
}
