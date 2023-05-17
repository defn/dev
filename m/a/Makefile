gen:
	go get istio.io/tools/cmd/cue-gen
	go install istio.io/tools/cmd/cue-gen
	git checkout ../go.mod ../go.sum
	~/go/bin/cue-gen -f=cue.yaml --crd=true
