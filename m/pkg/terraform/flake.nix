{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-terraform"; };

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
        sha256 = "sha256-Jl0ooabdgb3Vgi66VWY2E7elHFgtZj+UF/h3eQXTkAI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-38glvUiGeRY6J2jzyHJhzkO0dHcgpsxOKmOTWWHORYI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-iarOiRR8oA1SACgqp2aGbjImjhkdl6zsp2Kfwjeaqrk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-J4NKZFDEBGr4EtzD+v88DFbIxJnKmZDXzUPvf4RAd+0="; # aarch64-darwin
      };
    };
  };
}
