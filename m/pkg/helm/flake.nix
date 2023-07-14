{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-K276oAmJHTcDhp9L6Aq4b6oz+oPZ1f8vZJKorr6Xshk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-z6+66Fwxr96Ixp8OUFNhDIxFWCYIHBstZl2bRMMbN1k="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-bov8hKZA4NxHzEnPwtCkgvAR9CSeLf8qfiPH7y3xtk4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-tg7haEfiiHmuKYogukZy/IT3QUEPQ45kUncgWCTdv1U="; # aarch64-darwin
      };
    };
  };
}
