{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-earthly"; };

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-dsiW/fFAe53lbH8bQ7779mQHPl0/mD4CVvfYDrZ+sCY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-AHJ/xJ+SplGJAyBJ9t4OWzDqKzINxEW1ZEB0d3qVI6I="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-i6OUxvNnbk0vQYaGhT8FX4LLvE+DTLZyFHtDVdkWvhE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-hAX+tXcmnPLOzKK7hBz1QdafQ3RNZy6FjEab/v4H1ek="; # aarch64-darwin
      };
    };
  };
}
