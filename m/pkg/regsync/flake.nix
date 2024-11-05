{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regsync"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regsync-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-U/fMWhyMrplhxqXH+otlUUYeyTudTv5v76bm/dYMPug="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-MqEdhQtBR+5clK9ME39uAl6MdVBX8ZLyaQmgr1LfHrk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-3fg0WzJfrCFVgC8OTN3Wq+gL/TPTn5m1u3+CbWgphS0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ffwrxBFp3Nj1BoCVsxG6gs2+p6+l+nH1lxWqe1kpmgg="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regsync
    '';
  };
}
