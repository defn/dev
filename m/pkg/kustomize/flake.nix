{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-kustomize"; };

    url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.vendor}/kustomize_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kustomize $out/bin/kustomize
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-OrMvkjYNdSoqU+Vr4HO2SavB5zUbkSwPsyuWDR3vhUw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-oexiLUretIPjzavXDw1mBYseS87AE8T3TzcGZuHgRdg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-u9YKnDpSRmk2HGfL4qbBTQ8mzQQj+QS09cIEJg0W/G4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-puKwt+ga42BgJjdWSK5kW92PFg5CxpWvGjBmYjs7xUw="; # aarch64-darwin
      };
    };
  };
}
