{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-terraformdocs"; };

    url_template = input: "https://github.com/terraform-docs/terraform-docs/releases/download/v${input.vendor}/terraform-docs-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 terraform-docs $out/bin/terraform-docs
    '';

    downloads = {
      options = pkg: { };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-3XQaDs6BBZpHhoS0FNldcri3T6WPUKxANrTotWEw1ks="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-69p92jofZ46ePvLwkcl7Q/NKWhtS+5sdP0SgA/SB6LU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-/D+lUDfjXxt20cfoTtWotBLqau2CZN8FDh9pL60drik="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-xOjYY1cbjVECCJoiUAQmoYCUhVBA6wfkuD5N/RgW3SM="; # aarch64-darwin
      };
    };
  };
}
