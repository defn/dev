{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/alexellis/k3sup/releases/download/${input.vendor}/k3sup${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3sup
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "";
        arch = "";
        sha256 = "sha256-EX0MjgTMZPd42C6jZCzokcOR7T3HDt49yZHWGWXL8Wg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-JLc373BYwTMhM+lUt8kzzO0y7YJ7x2Nu4u6BxXoD25I="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-wW9ncg9mr6JT+CF2oqtqk4d8iH6Pk9PA9avgLh+D6hA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-ZxATOZVC9cq5iGRMMecKpkyhnn6R66x05YVMCxki3lM="; # aarch64-darwin
      };
    };
  };
}
