#!/usr/bin/env bash

set -euo pipefail

function main {
	local flake_helm
	local karpenter_values
	local out

	flake_helm="$1"
	shift
	karpenter_values="$1"
	shift
	out="$1"
	shift

	"${flake_helm}" template karpenter --namespace default --version v0.28.1 --include-crds -f "${karpenter_values}" oci://public.ecr.aws/karpenter/karpenter | tail -n +3 >"${out}"
}

main "$@"
