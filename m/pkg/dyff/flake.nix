{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dyff"; };

    url_template = input: "https://github.com/homeport/dyff/releases/download/v${input.vendor}/dyff_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dyff $out/bin/dyff
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-T6C8OaSvRjoLko6SI8ES0GbXjtQAfvUN1BG+ap7wn1I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WOVbRHC99sjLO3XmQHFquuQcvhpTZ5oPEQtxB4jHbxY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-cZ2Ik2C+ecKDjyPHVUwyIC5o5ATo82UXgBg8VOxf2Sw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-fzdShnjEv0/5g73pXRDq7uh79cQuoZTrLR+TQsZNGoA="; # aarch64-darwin
      };
    };
  };
}
