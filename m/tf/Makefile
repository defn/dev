# Install CDKTF CLI via npm in parent directory
# Dependencies: npm command, ../package.json file
# Outputs: Installed CDKTF CLI in ../node_modules/.bin/cdktf
../node_modules/.bin/cdktf:
	cd .. && npm install

# Download Terraform providers and regenerate code
# Dependencies: ../node_modules/.bin/cdktf binary, make command, CDKTF configuration files
# Outputs: Downloaded Terraform providers, regenerated code in parent directory
get: ../node_modules/.bin/cdktf
	../node_modules/.bin/cdktf get
	cd .. && $(MAKE) regen

# Update Terraform modules from upstream CloudPosse repositories
# Dependencies: mod/MODULES file, git command, rm command
# Outputs: Cloned specified CloudPosse Terraform modules into mod directory, removed non-essential files (.git, .github, docs, examples, etc.)
update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	cd mod && for a in $$(cat MODULES); do git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*} || true; done
	rm -rf mod/terraform-*/{.git,.github,.gitignore,docs,examples,test,images,Makefile,README.md}