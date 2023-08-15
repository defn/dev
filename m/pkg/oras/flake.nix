{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/oras-project/oras/releases/download/v${input.vendor}/oras_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 oras $out/bin/oras
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-a1G4c2DTc908GbkdJifS79MgUTOAqHi28GcC9y/oxas="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-NSpbIdWEBBjHcQ+lXbmIHUakw+LA/bFGcvnfOLpm3T0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-NPEVNtwZH5rUKIZJ+X72m0eFSPiRyTLJcyMH8GTtMzE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-+qAYF5nw4CldffGIRBofiGnaeKUNpM9/sDzzXcdGsXg="; # aarch64-darwin
      };
    };
  };
}
