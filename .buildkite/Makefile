# Default target: Generate pipeline.yml and show GitHub diff
# Dependencies: pipeline.yml
# Outputs: GitHub diff display
all: pipeline.yml
	@env GIT_PAGER=cat j github::diff

# Generate Buildkite pipeline YAML from CUE configuration
# Dependencies: pipeline.cue
# Outputs: pipeline.yml
pipeline.yml: pipeline.cue
	cue export --out=yaml > $@
	trunk fmt .