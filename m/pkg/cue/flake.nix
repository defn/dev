{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cue"; };

    url_template = input: "https://github.com/cue-lang/cue/releases/download/v${input.vendor}/cue_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cue $out/bin/cue
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-YMRuxbkBkMIqlqs1Ka02PQO2hzMbvrbX2Al6KYPXcW0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-JzRnHXu0u0kW3dlr8M18nhD2Rff2VNdoTnm2jLiK+5M="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-q6W1mwqEVLzJ8cJYGKV+MpJRJ/F0rRBfiLfvHvNbpr8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-3LtYr1bVgzw7sVJeiha5KvlTONQW4HzdPxmX7J/mVyU="; # aarch64-darwin
      };
    };
  };
}
