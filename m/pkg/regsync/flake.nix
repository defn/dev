{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regsync"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regsync-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-i/en8YxnD9ssT4n1cPSTaZ4DVtqwc2RJ+gx9+7dt4D8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-f+ZLgLJ4di6XXNcpkZ/XBG3uKN7hg4jRJOz6f+5PJZ8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-1ayMsbNsoSPPCGsotgduGqTuf/UEk9PL9oG7z1ugitU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sxUV9z4UxF4KGKHpX16LsA0GJ8/5/YcCZMH4vBsq/dg="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regsync
    '';
  };
}
