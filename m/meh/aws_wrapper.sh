#!/bin/bash

rm -rf "$3"
mkdir -p "$3"

cat "$2" | while read -r org acc id; do
    if [[ -z "$org" ]]; then continue; fi
    exe="$3/$org-$acc"
    cat <<EOF > "$exe"
#!/bin/bash

export AWS_CONFIG_FILE="$1"
export AWS_PROFILE="$org-$acc-sso"
exec aws "\$@"
EOF
    chmod 755 "$exe"

    exe="$3/$org-$acc-console"
    cat <<EOF > "$exe"
#!/bin/bash

export AWS_CONFIG_FILE="$1"
exec aws-vault login "$org-$acc-sso-source"
EOF
    chmod 755 "$exe"

    exe="$3/$org-$acc-exec"
    cat <<EOF > "$exe"
#!/bin/bash

export AWS_CONFIG_FILE="$1"
exec aws-vault exec "$org-$acc-sso-source"
EOF
    chmod 755 "$exe"
done