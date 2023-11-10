{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/opentofu/opentofu/releases/download/v${input.vendor}/tofu_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 tofu $out/bin/tofu
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
        sha256 = "sha256-Puczx9Z6OdRk35xiRhXV3OB2uBjd/kkQz8wdmA4Lv/4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-XJSc1gH3/Kdw3pG6BaHFq3yMmQeI2opyntm1qvPyjd4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-qJl7P9EJR8JfPVJHW1PufPySEssON95iRBdMvhmMAD0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-R9JYumgnAr1zSVnooILG4genOs49QL/lGfu5XBQ2Eq4="; # aarch64-darwin
      };
    };
  };
}
