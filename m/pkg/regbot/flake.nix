{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regbot"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regbot-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-p0nSI3cJlQuaI/EUVC0P51LjQeinAlhWVsIQ2rF1JfY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3ni66GMJnRc6J/p/IX1MU8IQ0yVSN4dosrQXiXBJLr8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-zEYJtyndrASP9SYivOC0IIFKDZPKYnkCQ1zgt2Xs9/c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-m5MDhZQElLkK2jdBuHws9ergrijblvgsk30Xw+D33Kk="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regbot
    '';
  };
}
