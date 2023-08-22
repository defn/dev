{
  inputs = {
    tailscale.url = github:defn/dev/pkg-tailscale-1.48.1-1?dir=m/pkg/tailscale;
  };

  outputs = inputs: inputs.tailscale.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        inputs.tailscale.defaultPackage.${ctx.system}
        easyrsa
        openvpn
        wireguard-tools
        wireguard-go
      ];
    };
  };
}
