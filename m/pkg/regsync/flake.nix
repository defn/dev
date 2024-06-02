{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regsync"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regsync-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-wHI9YqLmC+4ww5wqRjODT80gnuzimSGRz0ODNa5rzRg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-W/KHBVl5b0i4lUtzab+0WGGLXa7m/w1Ojtv4HGuNf/Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-BPZ2BthwBY9SLsUsKrn4YCZBqwBEmQW0vCAk5gW3+0Y="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wAy9puy6Ksm7EREA5JdRLVZrm5vhFBWdYLngknwEknw="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regsync
    '';
  };
}
