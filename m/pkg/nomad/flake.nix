{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/nomad/${input.vendor}/nomad_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 nomad $out/bin/nomad
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
        sha256 = "sha256-ZafVpMat4BpEKSkBsFp8mFtEWeCgebXrVfXWFHTumOU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-itCE4zeVpSD/0jnVjXcUbUGNZ25+lITuHbaXUETcfhk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-HZ0iCh3zfsrO/bVRSQjeZfMy9Mrqrnk2xoCl2JrG+mI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-fInYwB1OkC89kZaa17+fx5LtY4Rsr29sYCxCjPBtSV0="; # aarch64-darwin
      };
    };
  };
}
