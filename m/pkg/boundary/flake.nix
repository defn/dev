{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-zJ0jAwZ5WKxj93KiamhPf2zaRmT32Pbjl1jcRu5t5UI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-UqZIrSVfrfb2xutliToVE0tw01HwiyujxejmbkVJBds="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-WcAe8AFGqnsN8VN2p8s99hO3uvXQTxkUV1RAN3LPWaM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-6eodmF398Y7b97o1mX/vpzHMox8+bQomBw1+yXFkC04="; # aarch64-darwin
      };
    };
  };
}
