all: pipeline.yml
	@env GIT_PAGER=cat j github::diff

pipeline.yml: pipeline.cue
	cue export --out=yaml > $@
	trunk fmt .