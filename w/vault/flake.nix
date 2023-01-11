{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.19?dir=dev;
    vault.url = github:defn/pkg/vault-1.12.2-4?dir=vault;
    acme.url = github:defn/pkg/acme-3.0.5-4?dir=acme;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = builtins.path { path = ./.; name = config.slug; };

      config = rec {
        slug = builtins.readFile ./SLUG;
        version = builtins.readFile ./VERSION;
      };

      handler = { pkgs, wrap, system, builders }: rec {
        packages.acme-issue = pkgs.writeShellScriptBin "this-acme-issue" ''
          domain="$1"; shift
          export CF_Token="$(pass cloudflare_$domain)"
          acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d "*.$domain"
        '';

        packages.acme-renew = pkgs.writeShellScriptBin "this-acme-renew" ''
          domain="$1"; shift
          acme.sh --renew --ecc -d "*.$domain"
        '';

        packages.vault-start = pkgs.writeShellScriptBin "this-vault-start" ''
          set -exfu

          vault server -config vault.yaml
        '';

        packages.vault-unseal = pkgs.writeShellScriptBin "this-vault-unseal" ''
          set -exfu

          pass Unseal_Key_1 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') http://localhost:8200/v1/sys/unseal
          pass Unseal_Key_3 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') http://localhost:8200/v1/sys/unseal
          pass Unseal_Key_5 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') http://localhost:8200/v1/sys/unseal
        '';

        packages.vault-seal = pkgs.writeShellScriptBin "this-vault-seal" ''
          set -exfu

          vault operator seal
          rm -f ~/.vault-token
          cd ~/.password-store && git add vault && git add -u vault && git stash
        '';

        packages.vault-backup = pkgs.writeShellScriptBin "this-vault-backup" ''
          set -exfu

          this-vault-seal
          cd ~/.password-store
          git stash apply
          git add vault
          git add -u vault
          git commit -m "backup vault"
          git push
          git status -sb
          this-vault-unseal
        '';

        devShell = wrap.devShell {
          devInputs = with packages; [
            vault-start
            vault-unseal
            vault-seal
            vault-backup
            acme-issue
            acme-renew
          ];
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
