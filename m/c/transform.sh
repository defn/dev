#!/usr/bin/env bash

set -efu -o pipefail

function main {
	cue eval -c >/dev/null

	rm -rf docs/src/content/aws
	mkdir -p docs/src/content/aws

	for site in $(yq '.config.site | keys[]' main.yaml); do
		export site

		mkdir -p ../site/$site

		yq '.config.site[strenv(site)].package_json' main.yaml >../site/$site/package.json
		yq '.config.site[strenv(site)].astro_config_mjs' main.yaml >../site/$site/astro.config.mjs

		yq '.config.site[strenv(site)].tailwind_config_mjs' main.yaml >../site/$site/tailwind.config.mjs
		yq '.config.site[strenv(site)].tsconfig_json' main.yaml >../site/$site/tsconfig.json
		yq '.config.site[strenv(site)].wrangler_toml' main.yaml >../site/$site/wrangler.toml
		yq '.config.site[strenv(site)].mise_toml' main.yaml >../site/$site/mise.toml
	done

	for org in $(yq '.config.aws.org | keys[]' main.yaml); do
		export org

		for acc in $(yq '.config.aws.org[strenv(org)].account | keys[]' main.yaml); do
			export acc
			mkdir -p docs/src/content/aws/$org
			(
				echo "# auto-generated: transform.sh"
				yq '.config.aws.org[strenv(org)].account[strenv(acc)]' main.yaml
			) >"docs/src/content/aws/$org/$acc.yaml"

			mkdir -p ../aws/$org/$acc/.aws
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].aws_config' main.yaml >../aws/$org/$acc/.aws/config

			yq '.config.aws.org[strenv(org)].account[strenv(acc)].mise_config' main.yaml >../aws/$org/$acc/mise.toml

			# Generate account subdirectory README
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].account_readme' main.yaml >../aws/$org/$acc/README.md

			if [[ $acc == "org" ]]; then
				mkdir -p ../infra/org-$org
				(
					echo "# auto-generated: transform.sh"
					cat ../aws/$org/$acc/mise.toml
				) >../infra/org-$org/mise.toml

				# Generate org-level infra README
				yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_org_readme' main.yaml >../infra/org-$org/README.md

				# Generate org-level Terraform
				yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_org_terraform' main.yaml >../infra/org-$org/cdk.tf
			fi

			mkdir -p ../infra/acc-$org-$acc
			(
				echo "# auto-generated: transform.sh"
				cat ../aws/$org/$acc/mise.toml
			) >../infra/acc-$org-$acc/mise.toml

			# Generate account-level infra README
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_acc_readme' main.yaml >../infra/acc-$org-$acc/README.md

			# Generate account-level Terraform
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_acc_terraform' main.yaml >../infra/acc-$org-$acc/cdk.tf
		done
	done
}

main "$@"
