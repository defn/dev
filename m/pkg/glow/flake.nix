{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/glow/releases/download/v${input.vendor}/glow_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 glow $out/bin/glow
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-0iS+AG/E7jYcHRqF29RsJpNyt2xUE+Kpv9D3/lLGb3g="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-M2YafZeSVyQznU8G5jPffbyY6KcDIGaCNolb4bTIEl8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-B/I9FgnVAldN+ZJZBT8kNy2LojFTglKMs74xZhEFykQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-CO0Y6uZse7p/ApUtabD9uO3KuwgwyFqYrZY/JCLDM04="; # aarch64-darwin
      };
    };
  };
}
