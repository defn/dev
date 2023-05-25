{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-cd/releases/download/v${input.vendor}/argocd-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argocd
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-vS03PQJ3i1ltqgX856dvPjvCiH4QsWa+GsyK2LvsjDM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WoixV7dzOTYI5yF4/yeTXu8Bet/sOHfWwkoMH7rWGEY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-I1Aez/4BXyvmnCrGJwlWU5RJyI8y2mUJPXgOhsAo7PU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-QaiW2syfabCcFHxVaEHWvUKwEXF+VpgHDJnuQ0p7cBQ="; # aarch64-darwin
      };
    };
  };
}
