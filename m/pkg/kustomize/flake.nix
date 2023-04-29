{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.vendor}/kustomize_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kustomize $out/bin/kustomize
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-3KYjs2rvhPvfKPedAumzcF/2QUJKwfhy1UINrbEvt40="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-xuA2xcfu5MFfdUTkQc7Vy2z566JKARwlAI31YXzS+4U="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Siuff60DVci+oI2m3ZxI55DfXzV5gygJmNgLjcetPe8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-smT+kx6F2Mp8esR4cmlbH6Of4rc8/A1Yy9ygveadC8A="; # aarch64-darwin
      };
    };
  };
}
