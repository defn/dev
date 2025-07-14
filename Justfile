# Import GitHub-related recipes
mod github 'm/common/github.Justfile'
# Import GPG-related recipes
mod gpg 'm/common/gpg.Justfile'
# Import common library functions
mod lib 'm/common/lib.Justfile'

# Run dyff (YAML diff tool) with arguments
# Dependencies: m/common/github.Justfile, dyff command
# Outputs: YAML diff output to stdout
dyff *args:
	@just github::dyff {{args}}
