{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/packer/${input.vendor}/packer_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 packer $out/bin/packer
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
        sha256 = "sha256-NP5I0NX5lnCvFdijtYHbfOnQgJPONyQNfHuZbeeUcnU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-AB8MjoV0K/LC+e91HsHWsdL9+Oo8HbSxq7dzQMXij8g="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-s+2I1BTG3KadIXO18D1r+OL5tlEQuG3/87l5Nz71MFo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-2OSc8w8IXxiJvRbrai+0Sy/3FtLBVgyVMcXjgr+BOWU="; # aarch64-darwin
      };
    };
  };
}
