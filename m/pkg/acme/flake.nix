{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    extend = pkg: {
      sourceRoot = ".";

      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/acme.sh";
      };
    };

    url_template = input: "https://github.com/acmesh-official/acme.sh/archive/refs/tags/${input.vendor}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin $out/bin/dnsapi
      install -m 0755 */acme.sh $out/bin/acme.sh
      cp */dnsapi/* $out/bin/dnsapi/
    '';

    downloads = {


      "x86_64-linux" = {
        sha256 = "sha256-q9RG1r1F0LRNyh3L2TE0h5ej+C0e1vsXFHLq+FGo2Ek="; # x86_64-linux
      };
      "aarch64-linux" = {
        sha256 = "sha256-q9RG1r1F0LRNyh3L2TE0h5ej+C0e1vsXFHLq+FGo2Ek="; # aarch64-linux
      };
      "x86_64-darwin" = {
        sha256 = "sha256-q9RG1r1F0LRNyh3L2TE0h5ej+C0e1vsXFHLq+FGo2Ek="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        sha256 = "sha256-q9RG1r1F0LRNyh3L2TE0h5ej+C0e1vsXFHLq+FGo2Ek="; # aarch64-darwin
      };
    };
  };
}
