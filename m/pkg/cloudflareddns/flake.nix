{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/mattolenik/cloudflare-ddns-client/releases/download/v${input.vendor}/cloudflare-ddns-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cloudflare-ddns
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-1+m/TrlveZ9stWdisvA0ha7feffrdmZ/WN+j05tzao4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HRmSeH9e9ib02oZNkosB4DvDQnDhyquKeMV+rmww4dU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-WDbOngj+B8KLOadM73nha+fAq3NjWVS0cAX28aYWDL0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-WDbOngj+B8KLOadM73nha+fAq3NjWVS0cAX28aYWDL0="; # aarch64-darwin
      };
    };
  };
}
