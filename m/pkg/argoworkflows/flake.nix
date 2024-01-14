{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-argoworkflows"; };

    url_template = input: "https://github.com/argoproj/argo-workflows/releases/download/v${input.vendor}/argo-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      cat $src | gunzip > argo
      install -m 0755 -d $out $out/bin
      install -m 0755 argo $out/bin/argo
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-7SC/uhkOmkzN4qtgOdmZe3UnHkvY6Pitwybck1/rTn8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-sbjWkIm8TVY+fBx9YEiQFSNSel1SV9d/UoqnXvlNWf4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-TllfN4jMNrctP1xcprBFrNZyL91aqjoRlWOs4Rd93/g="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-jma/msLlp4og9bwAYYFQaCAPc9cXUxuPwTqINfHJjlA="; # aarch64-darwin
      };
    };
  };
}
