fmt:
	$(MAKE) tf command="fmt ."

plan:
	$(MAKE) tf command="plan -out=.plan"

show:
	$(MAKE) tf command="show .plan"

init:
	$(MAKE) tf command="init"

locks:
	$(MAKE) tf command="providers lock -platform=darwin_amd64 -platform=darwin_arm64 -platform=linux_amd64 -platform=linux_arm64"

tf:
	terraform $(command)

update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	for a in $$(cat MODULES); do rm -rf $${a%:*}; git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*}; done
	rm -rf terraform-*/{.git,.github,.gitignore,docs,examples,test,Makefile,README.md}