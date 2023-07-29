update:
# sync upstream, reduce surface area of maintenance, keep readme, license for attribution
	for a in $$(cat MODULES); do rm -rf $${a%:*}; git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*}; done
	rm -rf terraform-*/{.git,.github,.gitignore,docs,examples,test,Makefile,README.md}
