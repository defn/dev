{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-u7bnxiAUWLI18zUoDzVJOVDc2FaCXdz9HTtArnV9XH0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-RKqglK4k0B6MNuMn4YN/0zd6D5FSYm2giDhMW8bZRWI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-2mVMng/U/LUMxdugUcHJzzmOIf+lBktHrImpaX4TnTk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-YbohDNZcU75cACHI/I4LlPTBIq/zL17Q5OqBcoEI6iA="; # aarch64-darwin
      };
    };
  };
}
