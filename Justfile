mod github 'm/common/github.Justfile'
mod gpg 'm/common/gpg.Justfile'
mod lib 'm/common/lib.Justfile'

dyff *args:
	@just github::dyff {{args}}
