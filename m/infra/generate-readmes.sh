#!/bin/bash
# Generate README.md files for each infrastructure directory

generate_global_readme() {
    cat > "infra/global/README.md" <<'EOF'
# Global Infrastructure

Cross-account and global AWS infrastructure resources.

## Usage

```bash
cd infra/global
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/global/terraform.tfstate`)
- **Profile**: `defn-org`
- **Provider**: AWS 5.99.1

## Resources

This directory contains Terraform configurations for global/cross-account resources that span multiple AWS organizations.
EOF
}

generate_org_readme() {
    local org=$1
    local org_title="$(echo ${org:0:1} | tr '[:lower:]' '[:upper:]')${org:1}"

    cat > "infra/org-${org}/README.md" <<EOF
# ${org_title} Organization Infrastructure

Organization-level Terraform configuration for the ${org} AWS organization.

## Usage

\`\`\`bash
cd infra/org-${org}
mise trust
terraform init
terraform plan
\`\`\`

## Configuration

- **Backend**: S3 (\`stacks/org-${org}/terraform.tfstate\`)
- **Profile**: \`${org}-org\`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
EOF
}

generate_account_readme() {
    local org=$1
    local account=$2

    cat > "infra/acc-${org}-${account}/README.md" <<EOF
# ${org}-${account} Account Infrastructure

Account-specific Terraform configuration for the ${org} organization's ${account} account.

## Usage

\`\`\`bash
cd infra/acc-${org}-${account}
mise trust
terraform init
terraform plan
\`\`\`

## Configuration

- **Backend**: S3 (\`stacks/acc-${org}-${account}/terraform.tfstate\`)
- **Profile**: \`${org}-${account}\`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
EOF
}

# Generate global README
generate_global_readme

# Generate org READMEs
for org in chamber circus coil curl defn fogg gyre helix imma immanent jianghu spiral vault whoa; do
    generate_org_readme "$org"
done

# Generate account READMEs
# Chamber (35 accounts)
for acc in 1 2 3 4 5 6 7 8 9 a b c d e f g h i j l m n o org p q r s t u v w x y z; do
    generate_account_readme "chamber" "$acc"
done

# Circus (5 accounts)
for acc in lib log net ops org; do
    generate_account_readme "circus" "$acc"
done

# Coil (4 accounts)
for acc in hub lib net org; do
    generate_account_readme "coil" "$acc"
done

# Curl (4 accounts)
for acc in hub lib net org; do
    generate_account_readme "curl" "$acc"
done

# Defn (1 account)
generate_account_readme "defn" "org"

# Fogg (10 accounts)
for acc in ci dev hub lib log net ops org prod pub; do
    generate_account_readme "fogg" "$acc"
done

# Gyre (2 accounts)
for acc in ops org; do
    generate_account_readme "gyre" "$acc"
done

# Helix (10 accounts)
for acc in ci dev hub lib log net ops org prod pub; do
    generate_account_readme "helix" "$acc"
done

# Imma (6 accounts)
for acc in dev lib log net org pub; do
    generate_account_readme "imma" "$acc"
done

# Immanent (12 accounts)
for acc in changer chanter doorkeeper ged hand herbal namer org patterner roke summoner windkey; do
    generate_account_readme "immanent" "$acc"
done

# Jianghu (3 accounts)
for acc in log net org; do
    generate_account_readme "jianghu" "$acc"
done

# Spiral (10 accounts)
for acc in ci dev hub lib log net ops org prod pub; do
    generate_account_readme "spiral" "$acc"
done

# Vault (10 accounts)
for acc in ci dev hub lib log net ops org prod pub; do
    generate_account_readme "vault" "$acc"
done

# Whoa (5 accounts)
for acc in dev hub net org pub; do
    generate_account_readme "whoa" "$acc"
done

echo "Generated $(find infra -name README.md | wc -l) README files"
