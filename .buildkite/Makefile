all: pipeline.yml

pipeline.yml: pipeline.cue
	cue fmt .
	cue export --out=json > $@
