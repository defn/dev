crd:
	time cue export --out json -e crds | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | while read -r domain crds; do echo "$$crds" | base64 -d > ../crd/$$domain.yaml; done
