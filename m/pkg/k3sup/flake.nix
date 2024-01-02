{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-k3sup"; };

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
        sha256 = "sha256-BjONXhNIz3lIIu/kx3NeENfuDeT9wKAhswEad5f6OPs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-2EQ87J9otWmOBbq46r62myK/2yMsura9wq6zHfUBdqY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-DEdaeW8r+v+frJHV4TI3hW9U9IilaJbLGTItD+CAu6A="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-HTRwMpxh2YEm98oyJbXMmfUxOhxpRLFfTFkmVvvIM6U="; # aarch64-darwin
      };
    };
  };
}
