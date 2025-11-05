#!/usr/bin/env bash

# Bundles multiple config files into a tarball
function main {
    local env="${in[env]:-production}"
    local out="${shome}/${out}"

    local tmp_dir="$(mktemp -d)"
    trap "rm -rf ${tmp_dir}" EXIT

    # Copy configs to temp dir with environment prefix
    mkdir -p "${tmp_dir}/configs/${env}"

    # Copy all config files passed as arguments
    for config_file in "${args[@]}"; do
        cp "${config_file}" "${tmp_dir}/configs/${env}/"
    done

    # Create manifest
    cat > "${tmp_dir}/manifest.txt" <<EOF
Environment: ${env}
Bundled: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Files:
$(cd "${tmp_dir}" && find configs -type f)
EOF

    # Create tarball
    tar czf "${out}" -C "${tmp_dir}" .
}

source b/lib/lib.sh
