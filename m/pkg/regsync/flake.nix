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
        sha256 = "sha256-sIpab55MW1ILzTHv9zIEggP/p9UCqRyik0MXqoJgyh8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3uhl4w0KeHSBXpPOBdobOWnobUFFlfBlaeAvLJl6cwk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-4+iAMRAIr9DKfMamZ4mr3UB78Ddx9sNFl7riQw233po="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-HVlZyR3NnL4SK1ILgSYeMMUnKMyQ8F5/1K7EK7qmOUM="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regsync
    '';
  };
}
