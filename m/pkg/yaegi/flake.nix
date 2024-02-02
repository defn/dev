{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/traefik/yaegi/releases/download/v${input.vendor}/yaegi_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-+DsG4CtM1PUfAvywwMtoSFRLuQelyTyTd/d6I7smj0w="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3sQvhs8LLWhZx+Xp9co009CzC6RHp8p+3HZnT16mQ+k="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-b26Tnpg9zw9SlCxFhkUJsZ96z9ehGkOHsqCnHsq4ApY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-7H5H1hIxe7g3SWsgsmgJRhoQwoM9HgkxxU1bySVNeH4="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 yaegi $out/bin/yaegi
    '';
  };
}
