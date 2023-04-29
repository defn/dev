{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-workflows/releases/download/v${input.vendor}/argo-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      cat $src | gunzip > argo
      install -m 0755 -d $out $out/bin
      install -m 0755 argo $out/bin/argo
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-pSagdh1rGXp0jdQxGaQTEfjvTDPC2G580t9X2mSeXVs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-36EoY707o1aaSaikRN2u+wfSvdZpVwBjmBM6Oykr1p4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-63gSAj9GvVFZNnkPbXu055wBbdAgo9NofKQMJ/uadKc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-1KWS12r5yNHKaS+YJAJkUTgU8T34Nufao7jqXTYwTaA="; # aarch64-darwin
      };
    };
  };
}
