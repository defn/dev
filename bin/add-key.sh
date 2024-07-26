#!/usr/bin/env bash

set -efu -o pipefail

function main {
  local identity="$1"; shift

	GNUPASS="$(mktemp -t "gnupg_$(date +%Y%m%d%H%M || true)_XXX)")"

	export GNUPASS

	gpg --gen-random --armor 0 24 >"${GNUPASS}"

	gpg --batch --passphrase-file "${GNUPASS}" --quick-generate-key "${identity}" rsa4096 cert 10y

	local FPR
	FPR="$(gpg --list-options show-only-fpr-mbox --list-secret-keys | awk '{print $1}')"

	gpg --batch --passphrase-file "${GNUPASS}" --pinentry-mode loopback --quick-add-key "${FPR}" rsa4096 sign 10y
	gpg --batch --passphrase-file "${GNUPASS}" --pinentry-mode loopback --quick-add-key "${FPR}" rsa4096 encrypt 10y
	gpg --batch --passphrase-file "${GNUPASS}" --pinentry-mode loopback --quick-add-key "${FPR}" rsa4096 auth 10y

	gpg --list-keys
	gpg -K

	echo export GNUPASS="${GNUPASS}"
}

main "$@"

