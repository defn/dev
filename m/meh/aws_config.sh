#!/usr/bin/env bash

set -efu

cat "$1" | while read -r org url region; do
	cat "$3" | perl -pe "s{ORG}{${org}}g; s{REGION}{${region}}g"
	cat "$2" | while read -r org2 member account_id; do
		if [[ ${org2} == "${org}" ]]; then
			echo "aws config: ${org} ${member} ${account_id}" 1>&2
			cat "$4" | perl -pe "s{ORG}{${org}}g; s{MEMBER}{${member}}g; s{REGION}{${region}}g; s{URL}{${url}}g; s{ACCOUNT_ID}{${account_id}}g"
		fi
	done
done >"$5.tmp"

mv -f "$5.tmp" "$5"
