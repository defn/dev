{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-workerd"; };

    url_template = input: "https://github.com/cloudflare/workerd/releases/download/v${input.vendor}/workerd-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      fname="$(echo $src | sed 's#.gz$##')"
      if ! test -f $fname; then
        zcat $src > workerd
        fname=workerd
      fi
      install -m 0755 $fname $out/bin/workerd
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "64";
        sha256 = "sha256-zdoz+VB08d+k7XwrbFZZ/UtuqpgwYEDeI9ltrve1Kn4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-P7jzN9/Ek8EKGSppZVdlFDDzmfJ9n+e1OYgB0nWlJbE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "64";
        sha256 = "sha256-sDmBijephFb5NPOOakVID9U4E/TcKViVb4fPDOv5DCs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ulP4R14xH8BdqLQWPxFYMUcARflHGUqUu6TnvIB88fE="; # aarch64-darwin
      };
    };
  };
}
