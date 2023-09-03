build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build

deploy:
	-kubectl delete pod shell-operator
	kubectl apply -f main.yaml

log:
	stern shell-operator