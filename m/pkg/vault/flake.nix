{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-yjPUrcVcw6w3JJGYJU8qhf7l+4eLN7z14fVTXeghYdg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-0DpLmY1hwUNLxG4zK4uFu61NErv9u7Eez/ZWGw4v8Ek="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-+qrduGJmHH4i60f1H4M9PMNVVhxoxjMAnwibAcdq48k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-XkEuJUH4mRgmVsiodXVVjMsDrMlfrQRwICv5ZXMYNqE="; # aarch64-darwin
      };
    };
  };
}
