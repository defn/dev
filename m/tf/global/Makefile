config:
	cue export ../../aws/aws-account.cue   | jq -r '.org[].account[] | "\(.org)-\(.account) \(.id)"' | while read -r acc_slug acc_id; do cat template/provider.es | env ACC_SLUG="$$acc_slug" ACC_ID="$$acc_id" envsubst; echo; echo; done > provider.tf
	b aws | sort | while read -r acc_slug; do cat template/s3.es | env ACC_SLUG="$$acc_slug" envsubst > s3-$$acc_slug.tf; done

init:
	b exec defn-org tf init
