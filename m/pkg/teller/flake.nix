{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/tellerops/teller/releases/download/v${input.vendor}/teller_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 teller $out/bin/teller
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-VyT1DsFfCRx+hVeyEvUhbEk77jDkevVK5UMK4y3e7hQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-X00ApBJt9uh13tuBZp7HHhACufewiP0XWCYfA6Z9pnk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-AEia8MpO3Ypi4dRl48AvtNr8ZJXzq/LZbGovTFYbXdQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-/d7sduvkUXvL26J6rr7yrTxpzX0ciGj5Iiv3363WJ+c="; # aarch64-darwin
      };
    };
  };
}
