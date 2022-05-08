login:
	flyctl auth login

%:
	flyctl deploy --config $@.toml

defn0:
	flyctl scale --app defn count 0

defn1:
	flyctl scale --app defn count 1
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu
