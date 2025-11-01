#!/bin/bash
# Generate README.md files for each AWS organization

generate_readme() {
    local org=$1
    local accounts=("${@:2}")
    local readme="a/${org}/README.md"

    # Capitalize first letter of org name for title
    local org_title="$(echo ${org:0:1} | tr '[:lower:]' '[:upper:]')${org:1}"

    cat > "$readme" <<EOF
# ${org_title} AWS Organization

AWS SSO configuration for the ${org} organization.

## Usage

Activate an account environment:

\`\`\`bash
cd a/${org}/ops
mise trust
aws sts get-caller-identity
\`\`\`

## Accounts

This organization contains ${#accounts[@]} AWS account(s):

EOF

    # Add account list
    for account in "${accounts[@]}"; do
        echo "- \`${account}/\` - ${org}-${account} profile" >> "$readme"
    done

    cat >> "$readme" <<'EOF'

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
EOF
}

# Generate READMEs for each organization
generate_readme "chamber" 1 2 3 4 5 6 7 8 9 a b c d e f g h i j l m n o org p q r s t u v w x y z
generate_readme "circus" lib log net ops org
generate_readme "coil" hub lib net org
generate_readme "curl" hub lib net org
generate_readme "defn" org
generate_readme "fogg" ci dev hub lib log net ops org prod pub
generate_readme "gyre" ops org
generate_readme "helix" ci dev hub lib log net ops org prod pub
generate_readme "imma" dev lib log net org pub
generate_readme "immanent" changer chanter doorkeeper ged hand herbal namer org patterner roke summoner windkey
generate_readme "jianghu" log net org
generate_readme "spiral" ci dev hub lib log net ops org prod pub
generate_readme "vault" ci dev hub lib log net ops org prod pub
generate_readme "whoa" dev hub net org pub

echo "Generated READMEs for all organizations"
