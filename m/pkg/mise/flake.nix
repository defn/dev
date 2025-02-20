{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-opwmAPzvwEiNPg4W1c/JzPzNsG9jSMTNQFCl7q+d1T0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/k+JmX2LTJ56HTrIczEX1UYwIcjIfwSkDesn00dSwV8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-uMBNQJm5lWtI45QqQ+ZCXmw6XIE9qLXBip1+tHPPUY8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-N29GPeUma0Rtp4x23gAwydLfiktcpYwGy2CKBcLLbQo="; # aarch64-darwin
      };
    };
  };
}
