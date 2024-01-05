all: pipeline.yml
	@env GIT_PAGER=cat b diff

pipeline.yml: pipeline.cue
	cue fmt .
	cue export --out=json > $@