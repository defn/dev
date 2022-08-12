#!/usr/bin/env bash

# https://serverfault.com/questions/818289/add-second-sub-key-to-unattended-gpg-key
# https://github.com/drduh/YubiKey-Guide/issues/244
# https://github.com/drduh/YubiKey-Guide/pull/282

# personal-cipher-preferences AES256 AES192 AES
# personal-digest-preferences SHA512 SHA384 SHA256
# personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
# default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
# cert-digest-algo SHA512
# s2k-digest-algo SHA512
# s2k-cipher-algo AES256
# charset utf-8
# fixed-list-mode
# no-comments
# no-emit-version
# keyid-format 0xlong
# list-options show-uid-validity
# verify-options show-uid-validity
# with-fingerprint
# require-cross-certification
# no-symkey-cache
# use-agent

function main {
    export GNUPGHOME="$(mktemp -d -t gnupg_$(date +%Y%m%d%H%M)_XXX)"
    export GNUPASS="$(mktemp -t gnupg_$(date +%Y%m%d%H%M)_XXX)"

    gpg --gen-random --armor 0 24 > "$GNUPASS"

    gpg --batch --passphrase-file "$GNUPASS" --quick-generate-key "defn Nghiem <iam@defn.sh>" rsa4096 cert 1y

    local FPR="$(gpg --list-options show-only-fpr-mbox --list-secret-keys | awk '{print $1}')"

    gpg --batch --passphrase-file "$GNUPASS" --pinentry-mode loopback --quick-add-key "$FPR" rsa4096 sign 1y
    gpg --batch --passphrase-file "$GNUPASS" --pinentry-mode loopback --quick-add-key "$FPR" rsa4096 encrypt 1y
    gpg --batch --passphrase-file "$GNUPASS" --pinentry-mode loopback --quick-add-key "$FPR" rsa4096 auth 1y

    gpg --list-keys
    gpg -K

    echo export GNUPGHOME="${GNUPGHOME}"
    echo export GNUPASS="${GNUPASS}"
}

main "$@"
