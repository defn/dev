#!/usr/bin/env bash

function main {
	rm -rf docs/src/content/aws
	mkdir -p docs/src/content/aws

	for org in $(yq '.config.aws.org | keys[]' main.yaml); do
		export org

		for acc in $(yq '.config.aws.org[strenv(org)].account | keys[]' main.yaml); do
			export acc
			mkdir -p docs/src/content/aws/$org
			(
				echo "# auto-generated: transform.sh"
				yq '.config.aws.org[strenv(org)].account[strenv(acc)]' main.yaml
			) >"docs/src/content/aws/$org/$acc.yaml"

			mkdir -p ../a/$org/$acc/.aws
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].aws_config' main.yaml >../a/$org/$acc/.aws/config

			yq '.config.aws.org[strenv(org)].account[strenv(acc)].mise_config' main.yaml >../a/$org/$acc/mise.toml

			# Generate account subdirectory README
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].account_readme' main.yaml >../a/$org/$acc/README.md

			if [[ $acc == "org" ]]; then
				mkdir -p ../infra/org-$org
				(
					echo "# auto-generated: transform.sh"
					cat ../a/$org/$acc/mise.toml
				) >../infra/org-$org/mise.toml

				# Generate org-level infra README
				yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_org_readme' main.yaml >../infra/org-$org/README.md
			fi

			mkdir -p ../infra/acc-$org-$acc
			(
				echo "# auto-generated: transform.sh"
				cat ../a/$org/$acc/mise.toml
			) >../infra/acc-$org-$acc/mise.toml

			# Generate account-level infra README
			yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_acc_readme' main.yaml >../infra/acc-$org-$acc/README.md
		done
	done
}

main "$@"
