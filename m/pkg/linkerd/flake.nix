{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-linkerd"; };

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/stable-${input.vendor}/linkerd2-cli-stable-${input.vendor}-${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/linkerd
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "-amd64";
        sha256 = "sha256-duMxSLs1JI7GL/u7yLEl/AU/8ao+2Ya8FBDpbIkAaz8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-4liyxlXA2uY8KbtkuIbxybdBHmrv32109MxAQh46kjY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-jDTPuRY+Hgc0TJlJd7KTRdgZqlWiFrspdZI1Aa2hBjE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-zOPj2nUu/qF26TF7RebH0my0ADOfzDnF8eImKTwyXyQ="; # aarch64-darwin
      };
    };
  };
}
