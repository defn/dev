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
        sha256 = "sha256-Wlf/XbinNmTkW8/9g8l7MmuQ+nO7icHeYjtGPLT6bRQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-elK5Z7cAxr9QN9Z/lEoQUil6SviYNoncnep78jqgTPM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-uHkxsTSmWJ/6Za+mUQ4pu9ms3AJwsfgEjI0ShnJiCAw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-5Fa23hjcT/yWXHBDwLmK+3mOMFLduQw2oRQ3XmXgHfw="; # aarch64-darwin
      };
    };
  };
}
