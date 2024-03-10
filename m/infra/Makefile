build: ../node_modules/.bin/cdktf
	cue eval -c >/dev/null
	b build
	../node_modules/.bin/cdktf synth --hcl
# cdktf synth --hcl has a bug with Encrypt bool undefined
	runmany 'perl -pe "s{undefined}{true} if m{encrypt\s+=\s+undefined}" -i $$1' cdktf.out/stacks/*/cdk.tf
	runmany 'perl -pe "s{=}{= false} if m{(user_enabled|versioning_enabled|block_public_acls|block_public_policy|ignore_public_acls|restrict_public_buckets)\s+=\s+$$}" -i $$1' cdktf.out/stacks/*/cdk.tf
	runmany 'perl -pe "s{=}{= true} if m{(allow_public_website)\s+=\s+$$}" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from providers
	runmany 'perl -pe "s{\"}{}g if m{^\s*aws\s*=}" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from lifecycle stuff
	runmany 'perl -pe "s{\"ami\",}{ami,}g" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove quotes from strings
	runmany 'perl -pe "s{\\\\\"}{\"}g" -i $$1' cdktf.out/stacks/*/cdk.tf
# remove local backend path
	runmany 'perl -pe "s{^\s*path\s*=.*}{}g if m{tfstate}" -i $$1' cdktf.out/stacks/*/cdk.tf
# restore locks
	git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git reset --
	git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git checkout --
# add files to staging area for enumeration
	git add cdktf.out
	git add -u cdktf.out
	trunk fmt $(git ls-files .)
# add whitespace between blocks
	git ls-files cdktf.out | grep 'tf$$' | while read -r a; do perl -pe 's#^}$$#}\n#' $$a | awk 'NF {print; blank=0} !NF && !blank++ {print}' > $$a.tmp && mv $$a.tmp $$a; done
# fmt
	trunk fmt $(git ls-files .)
	git add -u .

../node_modules/.bin/cdktf:
	cd .. && npm install

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' cdktf.out/stacks/*/
