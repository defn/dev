build:
	cue eval -c >/dev/null
	b build
	cdktf synth --hcl
# symlink to modules to eliminate module copies in git
	runmany 'if test -d $$1; then rm -rf $$1/terraform-*; for a in mod/terraform-*; do ln -nfs ../../../../../../$$a $$1/; done; fi' cdktf.out/stacks/*/assets/*/*
# cdktf synth --hcl has a bug with Encrypt bool undefined
	runmany 'perl -pe "s{undefined}{true} if m{encrypt\s+=\s+undefined}" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from providers
	runmany 'perl -pe "s{\"}{}g if m{^\s*aws\s*=}" -i $$1' cdktf.out/stacks/*/cdk.tf

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' cdktf.out/stacks/*/

update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	cd mod && for a in $$(cat MODULES); do git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*} || true; done
	rm -rf mod/terraform-*/{.git,.github,.gitignore,docs,examples,test,images,Makefile,README.md}
	cd ../aws && b out aws_config_cfg > ../tf/.aws/config