{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-sOtfsN7O2+5ba9QV9yr4zmE1/7gSj5cJvHrc1cv6aQs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-wrLozNBc6jEWAO1H0qct+DWpP9W5tHDEL3skg5j0VZI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-VYaYU18zNRP0wbeJYJN75CcoyG3imEhJdtWwUiAz+z4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-ueZAkqCAsSuiCQbM5Wsk74oncrWqxBj5NlDR4f5pmvM="; # aarch64-darwin
      };
    };
  };
}
