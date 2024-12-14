{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-flyctl"; };

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-J2qWzb00hWYMekRZIRL3v5318uMhDYql7ZFdJwsEZnQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-kjGtr0osUgS4yaDzB0d6yxy/Iw7HX+fPJMi8aEdGiyg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-CFhCSBEBDrXhTtP5LhtbYHJbSzC3b939/gWeBREemBc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-sRIiJGf6lbUHn1imeuUviZ0QwErUBKTeDnAIcmj5BlE="; # aarch64-darwin
      };
    };
  };
}
