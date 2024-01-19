build:
	cdktf synth --hcl
	runmany 'perl -pe "s{undefined}{true} if m{encrypt\s+=\s+undefined}" -i $$1' cdktf.out/stacks/*/cdk.tf
	runmany 'if test -d $$1; then rm -rf $$1/terraform-*; for a in mod/terraform-*; do ln -nfs ../../../../../../$$a $$1/; done; fi' cdktf.out/stacks/*/assets/*/*

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' stacks/*/

update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	cd mod && for a in $$(cat MODULES); do git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*} || true; done
	rm -rf mod/terraform-*/{.git,.github,.gitignore,docs,examples,test,images,Makefile,README.md}
	cd ../aws && b out aws_config_cfg > ../tf/.aws/config