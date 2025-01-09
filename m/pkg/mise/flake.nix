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
        sha256 = "sha256-XOePqmMQ+FyQz6/SnzGuJ10fi40dH/tHZpINx8JHnhU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-d9WY0JDlF/LsK4P21NSJcHMh4q3jk10dZvHnto1Sp0U="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-XxUmxlFCiTtS2RdgVAPXu8xnTsm5EGfWMgP4dsgSkXY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-fZofnri+k0FqH5Hc3mp4MZuk/p0RmnxURDnd/fPvjCE="; # aarch64-darwin
      };
    };
  };
}
