{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-k9s"; };

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-SYcucgVPB1GqOsMWvVX2V3hP0G9JT7mXetsLobULRNc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-jG+Llhm+yJIxjkTrbpdf/IUXxyhqz9pO604OxVE34LY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-OqMEzS8g7aI87H3Wz7WRDUKKouQOG+K9XOJfHiE77QU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-dl2yy5/tPanIn68k5Dx4X0qEnitOFLsTCgWUf+uur9E="; # aarch64-darwin
      };
    };
  };
}
