{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
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
        sha256 = "sha256-qEQucEHbCn20j0aONT7gf6ans1J27GL2CBPFGMoylsE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-NxSeycoyKqUPJJpkXkPmdJi2fnhbNWxZ+bDw5lGdp44="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-iiof+HtwV7OmLavJDmh15uSnQnCYzCZnk66KjikuKDM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-0M+4hKVNkopdcxULmkkqW+hVEFtStMUKgQWbC+7O1Ag="; # aarch64-darwin
      };
    };
  };
}
