{
  inputs = {
    tailscale.url = github:defn/dev/pkg-tailscale-1.56.1-4?dir=m/pkg/tailscale;
    cloudflared.url = github:defn/dev/pkg-cloudflared-2024.1.3-1?dir=m/pkg/cloudflared;
  };

  outputs = inputs: inputs.tailscale.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-vpn"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        inputs.tailscale.defaultPackage.${ctx.system}
        inputs.cloudflared.defaultPackage.${ctx.system}
        easyrsa
        openvpn
        wireguard-tools
        wireguard-go
      ];
    };
  };
}
