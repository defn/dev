{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-G+kJDU5AxaNfrCeZjlMiLjwDRWMUii0Ls1OW+6HVAhQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-G77JBYaukpxxjnr+UzNNA1sTO1p6aB3QiHvPpnT89xY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-xZ85Ob76A3iACofFzHJpJo55WJ/A6vfMlWfFaDoY6DQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-tIV0l2ejUflepaR4Ki2lnKltm967bSVGQLJberUHvkY="; # aarch64-darwin
      };
    };
  };
}
