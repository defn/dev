{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/terraform/${input.vendor}/terraform_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 terraform $out/bin/terraform
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
        sha256 = "sha256-eB/+DIiI01s/W9BIHpUc6+mWS5z8sn41LyJoeXVAG80="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-w5oIGDD3CPqeUOX+FGJSXe1N4bQwjc+R9kkU1vTpiLM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-BIS1x9XaoXz/9HbymwJzmNgFwAqMJ2+IRzS0xvrdFew="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-dcVjLyIa27o41Wm9rrbDy5C3+C4msB45s7fhwWuw5NQ="; # aarch64-darwin
      };
    };
  };
}
