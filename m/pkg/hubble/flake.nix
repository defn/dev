{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/cilium/hubble/releases/download/v${input.vendor}/hubble-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 hubble $out/bin/hubble
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-/jae8cR0+RgGRgPdqNeP2FULD2dmHyGa6RZ6E80Vayo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-oC3MLMyq33lbaaZDXwFpseHlLHqAicAKn3cv03hVhz8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-V11bAQETpWlAJe60ptk1AiQOfV5K0F7N8g96vnRyjJM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-0W0C7SWYXswZsWa29tuXPUtfsA94+d+uUJ/BjCoErZ4="; # aarch64-darwin
      };
    };
  };
}
