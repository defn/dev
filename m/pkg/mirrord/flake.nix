{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-mirrord"; };

    url_template = input:
      if input.os == "mac" then
        "https://github.com/metalbear-co/mirrord/releases/download/${input.vendor}/mirrord_${input.os}_${input.arch}"
      else
        "https://github.com/metalbear-co/mirrord/releases/download/${input.vendor}/mirrord_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out/bin
      install -m 0755 $src $out/bin/mirrord
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-WmfLSeYUFXpB92ZM2r511fD4DRcwpoUCfn9ODzg1Gy4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-W1xNz8cv7lRbWH8UvKhiGeRVfg5dbGpEkU+8o/GeBw4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "universal";
        sha256 = "sha256-lOiXficHVj9sH7sbJW9dxSGuUgTeRMb4HZtsLyvq98Y="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "universal";
        sha256 = "sha256-lOiXficHVj9sH7sbJW9dxSGuUgTeRMb4HZtsLyvq98Y="; # aarch64-darwin
      };
    };
  };
}
