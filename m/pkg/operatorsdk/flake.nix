{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/operator-framework/operator-sdk/releases/download/v${input.vendor}/operator-sdk_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/operator-sdk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-+0w4a8pmVpXjETTLoZJWSwtQFfmDj+NPXyeYcIMw32o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-0MwNQ/9e9LZkh4Ilnrd8ONtnvZgHndfVlRb70sgET3c="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-rK7+j/PViZQ1yIZ83Cb3bXyR7A73AONRcc7yzswRY80="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/y3UHQ6p6GDQNcvlPUNwaeHmsNmwbsCuckpaINugrsY="; # aarch64-darwin
      };
    };
  };
}
