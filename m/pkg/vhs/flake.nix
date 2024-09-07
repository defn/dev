{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/charmbracelet/vhs/releases/download/v${input.vendor}/vhs_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */vhs $out/bin/vhs
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-A3HltXszUzAnKrppkmVrZ4Xi5dhTjW5Nhdz9n3BADFs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-hiXysCulp2JoQeMEW+dnyh2jCSD7VntkiDh8GkeFPbk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-C/BGKRYi/k78Jn/ltCmgvykRb0BofwUl6vnIRb8ysN8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-WZe0h1I1iVRDmtb8Hy2iG3flLVQSJAwTt9HscxFKIYg="; # aarch64-darwin
      };
    };
  };
}
