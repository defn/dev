config:
	for a in $$(b aws); do cat template/provider.es | env PROFILE="$$a" envsubst; echo; echo; done > provider.tf
	for a in $$(b aws | egrep -E '^(defn|imma)'); do cat template/account.es | env ACCOUNT="$$a" envsubst; echo; echo; done > account.tf