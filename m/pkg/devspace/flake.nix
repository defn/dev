{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-devspace"; };

    url_template = input: "https://github.com/devspace-sh/devspace/releases/download/v${input.vendor}/devspace-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/devspace
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-xPpXZMn74f6n6xp5OgR4Fvr5MLNjiCsUCwAzND+8Ccg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-PkSWo4Da8WN5pOKxcb7cA25kYvyhD7t1LlbOpbP/d7s="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-9NI5GNJ8o2e4pB6kBA7HrK+ktmhOsIBngM0OlZF4B8c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-+Ffw7MRE9+ydwZAqXa1dJ6E24KM4dBBLMaNUT/xxzI4="; # aarch64-darwin
      };
    };
  };
}
