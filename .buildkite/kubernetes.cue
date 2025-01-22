package bk

#RunAsUbuntu: securityContext: {
	runAsNonRoot: true
	runAsUser:    1000
	runAsGroup:   1000
}

#BashContainer: {
	imagePullPolicy: "Always"

	command: ["bash", "-c"]

	#RunAsUbuntu
}

#BashStep: {
	#label: string
	#key:   string | *#label
	#image: string
	#args: [...string]
	#volumeMounts: [...{...}]
	#volumes: [...{...}]

	label: string | *#label
	key:   string | *#key

	plugins: [{
		kubernetes: podSpec: {
			containers: [{
				#BashContainer

				image:        #image
				args:         #args
				volumeMounts: #volumeMounts
			}]
			volumes: #volumes
		}
	}]
}

#WorkStep: #BashStep & {
	#volumeMounts: [{
		name:      "work"
		mountPath: "/home/ubuntu/work"
	}]

	#volumes: [{
		name: "work"
		emptyDir: {}
	}]
}
