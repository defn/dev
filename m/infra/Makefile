default:
	mise install
	mise exec -- npm install
	mise exec -- $(MAKE) build

build:
	cue eval -c >/dev/null
	cd ../cmd && b build
	env JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=1 ./node_modules/.bin/cdktf synth --hcl
	runmany 'perl -pe "\
		s{when\s*=\s*\"create\"}{when = create}g; \
		s{\"ami\",}{ami,}g; \
		s{default\s*=\s*$$}{default = \"\"\n}g; \
		s{^\s*path\s*=.*}{}g if m{tfstate}; \
		s{\\\\\"}{\"}g; \
		s{\"}{}g if m{aws = \"aws}; \
		" -i $$1' cdktf.out/stacks/*/cdk.tf
# add files to staging area for enumeration
	git add cdktf.out
	git add -u cdktf.out
	terraform fmt $$(git ls-files . | grep 'tf$$') || true
# add whitespace between blocks
	git ls-files cdktf.out | grep 'tf$$' | while read -r a; do perl -pe 's#^}$$#}\n#' $$a | awk 'NF {print; blank=0} !NF && !blank++ {print}' > $$a.tmp && mv $$a.tmp $$a; done
# fmt
	trunk fmt
# add mod symlinks
	runmany 'ln -nfs ../../../../tf/mod $$1/' cdktf.out/stacks/*/
# restore locks
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git reset --
	-git status -sb | grep lock.hcl | awk '{print $$2}' | xargs git checkout --
# final add
	git add -u .

upgrade:
	runmany 'cd $$1 && tf upgrade && tf locks' cdktf.out/stacks/*/
