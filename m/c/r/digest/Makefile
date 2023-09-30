cache:
	(cue export --out json -e image_digests | jq -r '.[]' | awk '{print $$2}') | this-k3d-save-images
