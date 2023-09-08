{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
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
        sha256 = "sha256-Qkqob4kUrh5wwf1gtEgS8HkwFTz99huVytI29E8PnK4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-j21udr20siG8/xJ29x+9E/QsRLWaNQUQK0mPcnBJ33M="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-0w+rJBVFdiQ74JtUogl1mSNwKNvy2CN+wux90Jyb2MY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-L8gnQmbhJe5z3GtftSjE4wt0v8HhLMxVouRUx2Jjmyw="; # aarch64-darwin
      };
    };
  };
}
