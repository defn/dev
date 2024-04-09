# List AWS account names
default:
	@b pass run //aws:aws__list_accounts

# Open AWS console in browser
console acc:
	#!/usr/bin/env bash
	set -exfuo pipefail

	account="{{acc}}-sso-source"
	
	region="${1:-${AWS_REGION:-${AWS_DEFAULT_REGION:-us-east-1}}}"
	url=$("$0" pass run //aws:aws__cli "${account}" aws-vault login "${account}" -- --region=${region} -s | sed 's#://#://us-east-1.#')
	encoded_url=$(printf "%s" "$url" | python -c 'import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read().strip()))')
	open "https://signin.aws.amazon.com/oauth?Action=logout&redirect_uri=${encoded_url}"

# Run a command under credentials
[no-cd]
exec acc:
	#!/usr/bin/env bash
	set -exfuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" -- aws-vault exec "${account}" -- "$@"

# Run a command under ECS server credential daemon
[no-cd]
server acc *args:
	#!/usr/bin/env bash
	set -exfuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" -- aws-vault exec --prompt=osascript --lazy --ecs-server "${account}" -- {{args}}

# Run aws cli 
[no-cd]
aws acc *args:
	#!/usr/bin/env bash
	set -exfuo pipefail

	account="{{acc}}-sso-source"
	b pass run //aws:aws__cli "${account}" aws {{args}}
