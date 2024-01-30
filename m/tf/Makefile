build: ../node_modules/.bin/cdktf
	cue eval -c >/dev/null
	b build
	../node_modules/.bin/cdktf synth --hcl
# symlink to modules to eliminate module copies in git
	runmany 'ln -nfs ../../../mod $$1/' cdktf.out/stacks/*
# cdktf synth --hcl has a bug with Encrypt bool undefined
	runmany 'perl -pe "s{undefined}{true} if m{encrypt\s+=\s+undefined}" -i $$1' cdktf.out/stacks/*/cdk.tf
	runmany 'perl -pe "s{=}{= false} if m{user_enabled\s+=\s+$$}" -i $$1' cdktf.out/stacks/*/cdk.tf
	runmany 'perl -pe "s{=}{= false} if m{versioning_enabled\s+=\s+$$}" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from providers
	runmany 'perl -pe "s{\"}{}g if m{^\s*aws\s*=}" -i $$1' cdktf.out/stacks/*/cdk.tf
# restore locks
	git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git reset --
	git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git checkout --
# fmt
	git add cdktf.out
	git add -u cdktf.out
	trunk fmt $(git ls-files .)
	git add -u .

../node_modules/.bin/cdktf:
	cd .. && npm install

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' cdktf.out/stacks/*/

update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	cd mod && for a in $$(cat MODULES); do git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*} || true; done
	rm -rf mod/terraform-*/{.git,.github,.gitignore,docs,examples,test,images,Makefile,README.md}
	cd ../aws && b out aws_config_cfg > ../tf/.aws/config