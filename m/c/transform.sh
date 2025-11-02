#!/usr/bin/env bash

function generate_org_readme {
	local org=$1
	local org_title=$(echo "${org:0:1}" | tr '[:lower:]' '[:upper:]')${org:1}
	local accounts=($(yq '.config.aws.org[strenv(org)].account | keys[]' main.yaml))
	local account_count=${#accounts[@]}

	cat >../a/$org/README.md <<EOF
# ${org_title} AWS Organization

AWS SSO configuration for the ${org} organization.

## Usage

Activate an account environment:

\`\`\`bash
cd a/${org}/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
\`\`\`

## Accounts

This organization contains ${account_count} AWS account(s):

EOF

	for acc in "${accounts[@]}"; do
		echo "- \`${acc}/\` - ${org}-${acc} profile" >>../a/$org/README.md
	done

	cat >>../a/$org/README.md <<EOF

## Structure

Each account directory contains:

- \`mise.toml\` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- \`.aws/config\` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from \`c/definition/aws/aws.cue\`. Do not edit manually.
EOF
}

function main {
	rm -rf docs/src/content/aws
	mkdir -p docs/src/content/aws

	# Track which orgs we've seen to generate org READMEs once per org
	declare -A org_readme_generated

	for org in $(yq '.config.aws.org | keys[]' main.yaml); do
		export org

		# Generate org README once per organization
		if [[ -z ${org_readme_generated[$org]} ]]; then
			generate_org_readme "$org"
			org_readme_generated[$org]=1
		fi

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

			if [[ $acc == "org" ]]; then
				mkdir -p ../infra/org-$org
				(
					echo "# auto-generated: transform.sh"
					cat ../a/$org/$acc/mise.toml
				) >../infra/org-$org/mise.toml

				# Generate org-level infra README
				yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_org_readme' main.yaml >../infra/org-$org/README.md
			else
				mkdir -p ../infra/acc-$org-$acc
				(
					echo "# auto-generated: transform.sh"
					cat ../a/$org/$acc/mise.toml
				) >../infra/acc-$org-$acc/mise.toml

				# Generate account-level infra README
				yq '.config.aws.org[strenv(org)].account[strenv(acc)].infra_acc_readme' main.yaml >../infra/acc-$org-$acc/README.md
			fi
		done
	done
}

main "$@"
