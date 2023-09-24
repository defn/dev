package l

page: content: html: """
	\(tutorial.html)
	"""

tutorial: #TutorialContent & {
	title: "Tutorial"
	steps: [{
		title: "Run Tilt to build and deploy the shell-controller."
		desc:  "tilt up"
	}, {
		title: "Open the Tilt web UI by pressing the space bar while in the shell panel."
		desc:  "Press s to stream logs.  This mode will no longer open the web UI."
	}, {
		title: "Edit main.sh file to change the shell-operator"
		desc: "Tilt will Live Update in the \"hook\" resource."
	}, {
		title: "Edit main.yaml file to change Kubernetes deployment."
		desc: "Then restart the (Tilt) resource in Tilt web UI."
	}, {
		title: "Get a shell in the operator pod."
		desc:  "kubectl exec -ti deploy/hook -- bash"
	}]
}
