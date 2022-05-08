login:
	flyctl auth login

defn:
	flyctl deploy --remote-only --config $@.toml
	while sudo ping -c1 defn; do :; done
	sleep 15
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu

%:
	flyctl deploy --remote-only --config $@.toml

defn0:
	flyctl scale --app defn count 0

defn1:
	flyctl scale --app defn count 1
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu
