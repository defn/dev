{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildifier"; };

    url_template = input: "https://github.com/bazelbuild/buildtools/releases/download/v${input.vendor}/buildifier-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildifier
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-GXYFPtTezW3ZMXCIW0OH7dx27HDcJpey6Rqa+DJpQYo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-kweMV3Y0k73CkU7TQFRFALjzSXNBpi6Q8A6eGExNnCw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gCsBMhHbz5HjwGWLoz7LOTLvWm9nZKCxPvzsTi3wTIM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-gz4q/DMbmtj2sDitPWnO6vl2UZAL8qOkX1T0LK/gv9M="; # aarch64-darwin
      };
    };
  };
}
