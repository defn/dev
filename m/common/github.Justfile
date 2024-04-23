# Wrapper for git diff that runs dyff
[no-cd]
diff *args:
	env GIT_EXTERNAL_DIFF="pwd 1>&2; just dyff" git diff {{args}}

# Internal dyff, called by git diff
[no-cd, private]
dyff +args:
	#!/usr/bin/env bash
	set -efuo pipefail

	set -- {{args}}
	shift # path
	old="$1"; shift
	shift # hex
	shift # mode
	new="$1"; shift
	shift # hex
	shift # mode

	case "${old}" in
		*.yaml | *.yml | *.json)
			dyff --color=yes between "${old}" "${new}" || true
			;;
		*)
			true
			;;
	esac

# Get GitHub token from git credential helper
[no-cd]
token:
	#!/usr/bin/env bash
	set -efuo pipefail

	(
		echo protocol=https
		echo host=github.com
	) | git credential fill 2>/dev/null | grep ^password= | cut -d= -f2-
