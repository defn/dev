# List AWS account names
# Description: Lists all available AWS account names using Bazel
# Dependencies: bazel (b), pass, //aws:aws__list_accounts target
# Outputs: List of AWS account names to stdout
default:
	@b pass run //aws:aws__list_accounts

# Open AWS console in browser
# Description: Opens AWS console for specified account in default browser with SSO login
# Dependencies: aws-vault, aws CLI, python, browser
# Outputs: Opens browser tab with AWS console for the account
console acc:
	#!/usr/bin/env bash
	set -efuo pipefail

	account="{{acc}}-sso-source"
	region="${1:-${AWS_REGION:-${AWS_DEFAULT_REGION:-us-east-1}}}"
	url=$(b pass run //aws:aws__cli "${account}" aws-vault login "${account}" -- --region=${region} -s | sed 's#://#://us-east-1.#')
	encoded_url=$(printf "%s" "$url" | python -c 'import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read().strip()))')
	open "https://signin.aws.amazon.com/oauth?Action=logout&redirect_uri=${encoded_url}"

# Run a command under credentials
# Description: Executes commands with AWS credentials for specified account
# Dependencies: bazel (b), pass, aws-vault, //aws:aws__cli target
# Outputs: Command output with AWS credentials in environment
[no-cd]
exec acc *args:
	#!/usr/bin/env bash
	set -efuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" -- aws-vault exec "${account}" -- {{args}}

# Run a command under ECS server credential daemon
# Description: Runs commands with ECS server credentials using aws-vault daemon
# Dependencies: bazel (b), pass, aws-vault, osascript, //aws:aws__cli target
# Outputs: Command output with ECS server credentials
[no-cd]
server acc *args:
	#!/usr/bin/env bash
	set -efuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" -- aws-vault exec --prompt=osascript --lazy --ecs-server "${account}" -- {{args}}

# Run aws cli
# Description: Runs AWS CLI commands with credentials for specified account
# Dependencies: bazel (b), pass, aws CLI, //aws:aws__cli target
# Outputs: AWS CLI command output
[no-cd]
cli acc *args:
	#!/usr/bin/env bash
	set -efuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" aws {{args}}
