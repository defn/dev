package pb

playbook: dump: [{
	name:  "Save host inventory"
	hosts: "all"
	tasks: [{
		name:        "Save inventory as json"
		delegate_to: "localhost"
		template: {
			src:  "debug_output.j2"
			dest: "../inventory/dump/{{ inventory_hostname }}.json"
		}
	}, {
		name:        "Convert inventory to CUE"
		delegate_to: "localhost"
		command: """
			cue import -p dump -l '"host"' -l '"{{ inventory_hostname }}"' ../inventory/dump/{{ inventory_hostname }}.json
			"""
	}]
}]
