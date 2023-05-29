{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/gruntwork-io/cloud-nuke/releases/download/v${input.vendor}/cloud-nuke_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cloud-nuke
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-bZQFzfC8cH2t2MIErEpVntUsacZ2GjzUC1mTSQ+gc5g="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-QPGTzOa6Rt0/Ncc5ARlQhwK0qvPUvNM9FNvVUaMzvLw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-+GH/m2tdPSd/9ByYmlF6aO3sJ2PxOXMN4Nb30Kh1rt8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-srwyhRwjiDhM1OJelxJ2Bg/xvzixbPpbjMiImmoqwM8="; # aarch64-darwin
      };
    };
  };
}
