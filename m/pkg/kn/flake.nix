{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/knative/client/releases/download/knative-v${input.vendor}/kn-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kn
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-/EXWDnVnCVveZw9gThE5Y5irM506SpEHyK2GHJTbUl0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-zYvVJtruQOstJiLMnIbxsQ+XP90cjHQYMezCn9EzWkw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-ixKOnGSULB9zLbEUs6hXXMzsWzkW+d8OwMe2s8C4mPY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9KZbqvxoIE/tUQQDFgMGqz9tKsBpwJUFz0Hno7UVA2o="; # aarch64-darwin
      };
    };
  };
}
