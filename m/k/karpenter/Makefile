karpenter.yaml:
	helm template karpenter --version v0.18.1 --include-crds -f values.yaml oci://public.ecr.aws/karpenter/karpenter | tail -n +3 > karpenter.yaml
