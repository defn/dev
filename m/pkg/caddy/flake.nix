{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/caddyserver/caddy/releases/download/v${input.vendor}/caddy_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 caddy $out/bin/caddy
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-o9pUdhq1k//F491Ozqj9c2ZjQzszaAVH5JwNXhdYX10="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-YgLdMDwh4+wy3Jos+4yJ7ASxA/Go86UdjPuzfUXpanY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "amd64";
        sha256 = "sha256-NBXvShxjsctBAYcNQolxKHqwGGnTLB8ZSnWwgVbtCVU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-fW15aHXSchfiLcGPSO4FLPu2n29vFAnYSXQm/idkeYw="; # aarch64-darwin
      };
    };
  };
}
