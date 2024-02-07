{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-q5+qHF2UmpgZv5R/ltDvYgy3Otkbz7GMO5Zga/jipvk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-RuxscfoiQUR3JHD+vo+eJFkn1YSsxkm8dlUnIUgn5w0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-ggFjxMOCy5gQUgpsoAhDY7kapYWHcEINgCfIQ5a0Ocs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-0Va161pWp53qtO2FftQuG6u12UGip7Xsx56SXskHTqg="; # aarch64-darwin
      };
    };
  };
}
