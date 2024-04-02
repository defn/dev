default:
	$(MAKE) all

-include ../common/Makefile.coder

all:
	env NIX_CONFIG="access-tokens = github.com=$$(b github)" $(MAKE) update upgrade	

list:
	@mkdir -p ~/.config/gh
	@yq --yaml-output -n --arg token "$$(b github)" --arg handle "$${GIT_COMMITTER_NAME}" '{"github.com": { users: { "\($$handle)": { oauth_token: $$token}}, git_protocol: "https", user: $$handle, oauth_token: $$token}}' > ~/.config/gh/hosts.yml
	@./make_list_vendor_updates.sh

update:
	@./make_update_flakes.sh

upgrade:
	n upgrade && n all update pkg deps
	n upgrade && n all update pkg deps || true
	git commit --allow-empty -m "finished upgrade"
