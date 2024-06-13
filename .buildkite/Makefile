all: pipeline.yml
	@env GIT_PAGER=cat j github::diff

pipeline.yml: pipeline.cue
	cue fmt .
	cue export --out=yaml > $@