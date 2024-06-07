{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dyff"; };

    url_template = input: "https://github.com/homeport/dyff/releases/download/v${input.vendor}/dyff_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dyff $out/bin/dyff
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-jUh/KBd/RK6EpTEFfB7e13uAdLDQWRwHfg7FVwuLx7c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-rMlMP79vylFNSemhHu5VkYP37NnqGhonpDhWxWqdG8Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-3Tfc1u7jtWcHyzEBGeJ8YorjrZO97LRT0EY4+mXeMec="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-bJrv1IQnVSPVZQSEaP2EwFKR+ujhiF0Fw+iYhyaLJp4="; # aarch64-darwin
      };
    };
  };
}
