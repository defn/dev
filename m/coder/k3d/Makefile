build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --K3S=1.26.7-k3s1 --image=169.254.32.1:5000/latest-k3d
	docker pull 169.254.32.1:5000/latest-k3d
	docker tag 169.254.32.1:5000/latest-k3d quay.io/defn/dev:latest-k3d
	docker push quay.io/defn/dev:latest-k3d