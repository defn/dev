package etc

#NomadJob: {
	ID:   Name
	Name: string
	Datacenters: [
		"dc1",
	]
	TaskGroups: [{
		"Name": Name
		Tasks: [{
			"Name":      Name
			Driver:    "raw_exec"
			User:      ""
			Lifecycle: null
			Config: {
				args: [...string]
				command: string
			}
			Resources: {
				CPU:      int
				MemoryMB: int
			}
		}]
	}]
}

jobs: [NAME=string]: #NomadJob & {
	Name: NAME
}

jobs: hello: {
	TaskGroups: [{
		Tasks: [{
			Config: {
				command: "bash"
				args: ["-c", "echo hello lamda; uname -a; pwd; exec sleep infinity"]
			}
			Resources: {
				CPU:      100
				MemoryMB: 128
			}
		}]
	}]
}
