#!/usr/bin/env bash

function main {
	local config="${in[config]}"
	local template_org="${in[template_org]}"
	local template_account="${in[template_account]}"

	while read -r org url region; do
		perl -pe "s{ORG}{${org}}g; s{REGION}{${region}}g" <"${template_org}"
		while read -r org2 member account_id sso_role; do
			if [[ ${org2} == "${org}" ]]; then
				echo "aws config: ${org} ${member} ${account_id}" 1>&2
				perl -pe "s{ORG}{${org}}g; s{MEMBER}{${member}}g; s{REGION}{${region}}g; s{URL}{${url}}g; s{ACCOUNT_ID}{${account_id}}g; s{SSO_ROLE}{${sso_role}}g;" <"${template_account}"
				echo
				echo
			fi
		done < <(jq -r '.org | . as $org | keys[] | . as $o | $org[$o].account | keys[] | . as $member | "\($o) \($org[$o].account[$member].account) \($org[$o].account[$member].id) \($org[$o].account[$member].sso_role)"' <"${config}" || true)
	done < <(jq -r '.org | . as $org | keys[] | "\(.) \($org[.].url) \($org[.].region)"' <"${config}" || true) >"${out}"
}

source b/lib/lib.sh
