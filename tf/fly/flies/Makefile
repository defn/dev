%:
	rsync -ia ~/.password-store/ .password-store
	flyctl deploy -a $@ --remote-only --config app.toml
