package l

page: content: html: """
	\(tutorial.html)
	"""

tutorial: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	steps: [{
		title: "Run Tilt to build and deploy the shell-controller."
		desc:  "tilt up"
	}, {
		title: "Open the Tilt web UI by pressing the space bar while in the shell panel."
		desc:  "Press s to stream logs.  This mode will no longer open the web UI."
	}, {
		title: "Edit hook.sh file to change the shell-operator"
		desc:  "Tilt will Live Update in the \"hook\" resource."
	}, {
		title: "Edit deploy.yaml file to change Kubernetes deployment."
		desc:  "Then restart the (Tilt) resource in Tilt web UI."
	}, {
		title: "Run a comand in the operator pod."
		desc:  "kubectl exec -ti deploy/hook -- /shell-operator queue list"
	}]
}
