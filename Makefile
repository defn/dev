devcontainer:
	devcontainer open .

build:
	docker build -t defn/dev .

push:
	docker push defn/dev