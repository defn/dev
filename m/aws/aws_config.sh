#!/usr/bin/env bash

set -efu

while read -r org url region; do
	perl -pe "s{ORG}{${org}}g; s{REGION}{${region}}g" <"$3"
	while read -r org2 member account_id; do
		if [[ ${org2} == "${org}" ]]; then
			echo "aws config: ${org} ${member} ${account_id}" 1>&2
			perl -pe "s{ORG}{${org}}g; s{MEMBER}{${member}}g; s{REGION}{${region}}g; s{URL}{${url}}g; s{ACCOUNT_ID}{${account_id}}g" <"$4"
		fi
	done <"$2"
done <"$1" >"$5.tmp"

mv -f "$5.tmp" "$5"
