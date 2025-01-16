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
        sha256 = "sha256-aN8LALd90Z33yRHUC5znFd0V52/J2JC6HszzH2Xp0xk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-McQ90AYttPFZBpvi7FrPFYFXFZ2cZIY1oBNwEtGCJwM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-oFvc48mok/Hh43eWuzVFjv15DRNfu35BIqDDpcNvZDw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-OOLWH4/LRqsLpb7wDzZPxqG2s2O3d4LJb+osu2QwKJI="; # aarch64-darwin
      };
    };
  };
}
