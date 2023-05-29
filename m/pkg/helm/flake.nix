{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-2jbhF9bbxXyOxbqyKDIi+9EI24bIM4nuvgRa0e8+LDs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ZYg5/tj5viFp9d9o5Vyy8KpzGlDfRUyvGDGGdmgAu9A="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-giO+t5b/GbWeYVOH0pvowgJcXTrqCEhaJiWD3nun1wg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-h59h0q0kXLP1AYq4tmqHYZ8ZWQSk3zsHfJjsB4DjbDc="; # aarch64-darwin
      };
    };
  };
}
