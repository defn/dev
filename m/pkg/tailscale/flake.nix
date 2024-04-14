{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tailscale"; };

    etc_src = ./etc;

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/tailscale";
      };

      apps.tailscaled = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/tailscaled";
      };
    };

    url_template = input: "https://pkgs.tailscale.com/stable/tailscale_${input.vendor}_${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin

      case "${pkg.config.os}" in
        darwin)
          install -m 0755 ${etc_src}/tailscale-darwin $out/bin/tailscale
          ;;
        *)
          install -m 0755 */tailscaled $out/bin/tailscaled
          install -m 0755 */tailscale $out/bin/tailscale
          ;;
      esac
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-qB7dzlGiJ34OaeKYeuQj6xpztespYdi5aNrcJ/37bc8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-tANoPtIpe80lFa9MQl2HK2JlvCH/gopV2qcS/hGiFRs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-qB7dzlGiJ34OaeKYeuQj6xpztespYdi5aNrcJ/37bc8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-tANoPtIpe80lFa9MQl2HK2JlvCH/gopV2qcS/hGiFRs="; # aarch64-darwin
      };
    };
  };
}
