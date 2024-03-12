build: ../node_modules/.bin/cdktf 
# check cue is concrete
	cue eval -c >/dev/null
# generate Terraform configs
	../node_modules/.bin/cdktf synth --hcl
# cdktf synth --hcl has a bug with Encrypt bool undefined
	PATH=$$PATH:../../../bin runmany 'perl -pe "s{undefined}{true} if m{encrypt\s+=\s+undefined}" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from providers
	PATH=$$PATH:../../../bin runmany 'perl -pe "s{\"}{}g if m{^\s*aws\s*=}" -i $$1' cdktf.out/stacks/*/cdk.tf
# restore locks
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git reset --
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git checkout --
# add files to staging area for enumeration
	git add cdktf.out
	git add -u cdktf.out
	trunk fmt || true
# add whitespace between blocks
	git ls-files cdktf.out | grep 'tf$$' | while read -r a; do perl -pe 's#^}$$#}\n#' $$a | awk 'NF {print; blank=0} !NF && !blank++ {print}' > $$a.tmp && mv $$a.tmp $$a; done
# fmt
	trunk fmt || true
	git add -u cdktf.out

../node_modules/.bin/cdktf:
	cd .. && $(MAKE) install