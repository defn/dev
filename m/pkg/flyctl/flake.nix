{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-DUy617lxTJ6vC9NzmeY/sVJ7sOzGtTxnUy7eEcvfuMA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-7bVU7oeGKRSX+kKvxESzr3ut+a8aifogYcNImIJfFkw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-FxLTBQFjLzHFTDnAAY4WlR+HbGCXF+OTzLrGB3xWSG4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-1NeDeNsT/dUe7oBBpCEyhuF9XZEABXjlZ3sE347t/Mk="; # aarch64-darwin
      };
    };
  };
}
