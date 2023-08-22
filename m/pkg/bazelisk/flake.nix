{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/bazelisk/releases/download/v${input.vendor}/bazelisk-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bazelisk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-zlLKpR755Qn7a35a2JLlzxD+sHlLCu1NLzatsAoaJ3k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-YHC/cJFekrOlzo7ub0qKCWi7NQviqYuAsP0vwTzoolQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-4zNn1cpwjn6erGNQ5WdgXrzu9qLehm1zkPMqGA7wSx0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-grNc4gCjkL+Qr2XGgUJFsnkhPYhYnXM76l8oh0Ki/u4="; # aarch64-darwin
      };
    };
  };
}
