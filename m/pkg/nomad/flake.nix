{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
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
        sha256 = "sha256-7b698QXa9Vah+em0DVjqpqCYTeUuyHyJAGh/nZhGW4Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DPaFCrjGCBqjtvyeewr4/chP81dNG2QC8ds+B4/l+DU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fYRqzu7r37a3UVTfq6JLtvwaJQf7U1pjwK5RUduivOs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-TBkDfI+bAmpIVzmTW9jhK/JNoJLhDIPMnSWmpDP1kZ8="; # aarch64-darwin
      };
    };
  };
}
