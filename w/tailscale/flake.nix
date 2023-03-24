{
  inputs = {
    pkg.url = github:defn/pkg/0.0.170;
    tailscale.url = github:defn/pkg/tailscale-1.38.2-0?dir=tailscale;
    cloudflared.url = github:defn/pkg/cloudflared-2023.2.1-4?dir=cloudflared;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.tailscale.defaultPackage.${ctx.system}
            inputs.cloudflared.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs
        ++ ctx.commands;
    };

    scripts = { system }: {
      tailscale-start = ''
        set -exfu

        sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscaled "$@"
      '';

      tailscale-up = ''
        set -exfu

        sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscale up "$@"
      '';

      tailscale-save = ''
        set -exfu

        sudo tar cvf - /var/lib/tailscale/tailscaled.state /var/lib/tailscale/certs | base64 -w 0 | pass insert -e -f $GIT_AUTHOR_NAME-tailscale
      '';

      tailscale-restore = ''
        set -exfu

        pass $GIT_AUTHOR_NAME-tailscale | base64 -d | (cd / && sudo tar xvf -)
      '';
    };
  };
}
