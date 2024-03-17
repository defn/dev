build: ../node_modules/.bin/cdktf
	cue eval -c >/dev/null
	b build
	../node_modules/.bin/cdktf synth --hcl
	runmany 'perl -pe "\
		s{undefined}{true} if m{encrypt\s+=\s+undefined}; \
		s{=}{= false} if m{(user_enabled|versioning_enabled|block_public_acls|block_public_policy|ignore_public_acls|restrict_public_buckets)\s+=\s+$$}; \
		s{=}{= true} if m{(allow_public_website)\s+=\s+$$}; \
		s{\"}{}g if m{^\s*aws\s*=}; \
		s{when\s*=\s*\"create\"}{when = create}g; \
		s{\"ami\",}{ami,}g; \
		s{\\\\\"}{\"}g; \
		s{default\s*=\s*$$}{default = \"\"\n}g; \
		s{^\s*path\s*=.*}{}g if m{tfstate}; \
		" -i $$1' cdktf.out/stacks/*/cdk.tf
# add files to staging area for enumeration
	git add cdktf.out
	git add -u cdktf.out
	terraform fmt $$(git ls-files . | grep 'tf$$')
# add whitespace between blocks
	git ls-files cdktf.out | grep 'tf$$' | while read -r a; do perl -pe 's#^}$$#}\n#' $$a | awk 'NF {print; blank=0} !NF && !blank++ {print}' > $$a.tmp && mv $$a.tmp $$a; done
# fmt
	terraform fmt $$(git ls-files . | grep 'tf$$')
# add mod symlinks
	runmany 'ln -nfs ../../../../tf/mod $$1/' cdktf.out/stacks/*/
# restore locks
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git reset --
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git checkout --
# final add
	git add -u .

../node_modules/.bin/cdktf:
	cd .. && npm install

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' cdktf.out/stacks/*/
