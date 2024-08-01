{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-packer"; };

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
        sha256 = "sha256-ztE+/CV9AlWTLRS4ro84hjJlEzc5oAfEMMrhBq/PxFo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3SltdD3UWTMEMHWDz/UpC7qbho/CsLYFtkVm+BQcpyg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-EHxDNLE2/7W4hLrIfy72Yg8V330dCmRtsguAVPnGB/4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-uJ9JRMyieDmSKjlySLlPwg2SrPFZM7s21Y620Sg9wlQ="; # aarch64-darwin
      };
    };
  };
}
