{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/vhs/releases/download/v${input.vendor}/vhs_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 vhs $out/bin/vhs
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-OXBlbeokMe83+rxgEWbdMEbnvbbeOALsUolnHQAOU8s="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-AfVu2uKeoAYAiEaqmDKnAG+LYw1C9onH+xrIAVgemBw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-zNBrXuGuaN8qmvE2LeqtynoAEpTplniuSiwRebqJlMc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-nkU3dg/4VLrQcMNMl6y5TD0IC7Zdg8YV7TOJVLP2qhE="; # aarch64-darwin
      };
    };
  };
}
