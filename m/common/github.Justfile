# Wrapper for git diff that runs dyff
# Description: Enhances git diff to use dyff for YAML/JSON file comparison
# Dependencies: git, just, dyff (for YAML/JSON files)
# Outputs: Standard git diff or enhanced dyff output for structured files
[no-cd]
diff *args:
	env GIT_EXTERNAL_DIFF="pwd 1>&2; just dyff" git diff {{args}}

# Internal dyff, called by git diff
# Description: Compares YAML/JSON files with structured diff output
# Dependencies: dyff
# Outputs: Colored structured diff for YAML/JSON files, nothing for other files
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
# Description: Retrieves GitHub authentication token from git credential store
# Dependencies: git with configured credential helper
# Outputs: GitHub token to stdout
[no-cd]
token:
	#!/usr/bin/env bash
	set -efuo pipefail

	(
		echo protocol=https
		echo host=github.com
	) | git credential fill 2>/dev/null | grep ^password= | cut -d= -f2-
