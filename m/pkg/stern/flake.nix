{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/stern/stern/releases/download/v${input.vendor}/stern_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 stern $out/bin/stern
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-3nlHTZGXWC442g3MyM0UryPWtStyvuBrYpQ8GauVEl4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-CChvcKoyBbf1tShkz5IKqQu09KYY57kfzxVca5eC2LY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-+JYx6nNlnh206djvlMWM0sTpLVleXSt76RhPhudV7pU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-px5AJ24XvhQQ2rWtQxXEoXJssU6fFg3Dyu6IscVpEbE="; # aarch64-darwin
      };
    };
  };
}
