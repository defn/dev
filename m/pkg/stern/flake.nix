{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/stern/stern/releases/download/v${input.vendor}/stern_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 stern $out/bin/stern
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-sHQB8ZrnR+J1o0ELddIiGFYJDnk1ZMMQJ8YjjjzOt5w="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-mynSkYiSHeWG0TRWMZTXP66wuRYFkBZsvhFbcqSmK2Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-6hZB9yFGhOuHgAqle5LkwTzdPANrjcDj7KQOsTk0Ygk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-aIQv82f+LJ2VFqXnX1wZbyOQn1fIUWLGFPz5bWvCAyU="; # aarch64-darwin
      };
    };
  };
}
