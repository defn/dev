{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/vault/${input.vendor}/vault_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 vault $out/bin/vault
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
        sha256 = "sha256-Z+ufldN5deJSW71FXhlSindZ86VgIt4GS/hgX8Igvkc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-q6/MPKwVcKu+e/miBywYvEjJ7340cHZlYvYi5rHgrvE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-cq/kHkdxEDao7VIa5ECIU9IHyPj58DhISr/+BchzcAU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-qJ1WX2a1ujtZZqsjp1TvTgJmRMm7SNrdAqLZcUR1rIY="; # aarch64-darwin
      };
    };
  };
}
