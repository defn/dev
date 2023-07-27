update:
	for a in $$(cat MODULES); do rm -rf $$a; git clone -b $${a#*:} https://github.com/cloudposse/$${a%:*}; done
