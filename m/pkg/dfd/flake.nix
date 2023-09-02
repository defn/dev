{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/amanibhavam/bin/raw/main/k3d";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/dfd
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        sha256 = "sha256-M8r1gEGJMz8LhojyEQwmlX4W5CuJ2UxI0Lz5azaDsc0="; # x86_64-linux
      };
      "aarch64-linux" = {
        sha256 = "sha256-M8r1gEGJMz8LhojyEQwmlX4W5CuJ2UxI0Lz5azaDsc0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        sha256 = "sha256-M8r1gEGJMz8LhojyEQwmlX4W5CuJ2UxI0Lz5azaDsc0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        sha256 = "sha256-M8r1gEGJMz8LhojyEQwmlX4W5CuJ2UxI0Lz5azaDsc0="; # aarch64-darwin
      };
    };
  };
}
