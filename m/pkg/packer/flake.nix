{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
        sha256 = "sha256-V9BBHleK6mKRjTbtGGlRE51dSdRLduVmbR+/JCezha4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-byit4AQPpA/bGZZru4fd3FsonXqpDGUDY41huq6lTRk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-eEaDHyzHjqjoWCquCP+qWpQfvuVSY2gj0ZyQ+VeMdbs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-CJAo7RY6u4o7rDdsmBd7aJw1yyKoY+2wZERR/faa84Y="; # aarch64-darwin
      };
    };
  };
}
