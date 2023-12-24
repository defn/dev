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
        sha256 = "sha256-ktvEnamNGQ0x12w0d3+v+oBJFc1gOQXlXQH7bzPwV44="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-Xn8ZVed7eVfmWYpqw0qlJNh3HnVO5nVhDAlmfq9+PsU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-LwjXcSWZfStGqgDdGJq2k2ajO8I6psyXLTNxrIP6zGI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-YbHJZJJb4d6nfkNqbq4vJWSFI33mHVgGRZB4FKa4mJY="; # aarch64-darwin
      };
    };
  };
}
