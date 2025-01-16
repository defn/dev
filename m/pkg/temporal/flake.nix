{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-temporal"; };

    url_template = input: "https://github.com/temporalio/cli/releases/download/v${input.vendor}/temporal_cli_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 temporal $out/bin/temporal
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-+x4IcRu5naP//DjSPm1YZ7XJnF4xAMgESDbIf0mFHTA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-OQrgMIUcHbFTjy4UWKF8D01qKQksa1+unUlBQ398U9Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-yXkGi/zTd61g5bIYfco6QgGjdKw9kYg7wdWDf+RWgSk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-gp9xJVFWyPCQ1bgV/DJnvDE7SND/pLh/Le8ISNSEGuM="; # aarch64-darwin
      };
    };
  };
}
