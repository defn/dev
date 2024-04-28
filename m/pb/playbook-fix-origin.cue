package pb

playbook: fix_git: [{
	name:  "fix git repo"
	hosts: "all:!penguin"
	roles: [
		"fix_origin"
	]
}]

role: fix_origin: tasks: [{
	name:  "git origin is https"
	shell: "cd && (git remote rm origin || true) && git remote add origin https://github.com/defn/dev && git fetch origin && git branch --set-upstream-to origin/main main"
	args: executable: "/bin/bash"
}]
