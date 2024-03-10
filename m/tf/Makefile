../node_modules/.bin/cdktf:
	cd .. && npm install

get: ../node_modules/.bin/cdktf
	../node_modules/.bin/cdktf get
	cd .. && $(MAKE) regen

update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	cd mod && for a in $$(cat MODULES); do git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*} || true; done
	rm -rf mod/terraform-*/{.git,.github,.gitignore,docs,examples,test,images,Makefile,README.md}