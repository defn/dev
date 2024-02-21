apiVersion: apps/v1
kind: Deployment
metadata:
  name: "${local.ns}"
  namespace: default
  annotations:
    com.coder.user.email: "${data.coder_workspace.me.owner_email}"
  labels:
    app.kubernetes.io/name: "${local.ns}"
    app.kubernetes.io/instance: "${local.ns}"
    app.kubernetes.io/part-of: "coder"
    com.coder.resource: "true"
    com.coder.workspace.id: "${data.coder_workspace.me.id}"
    com.coder.workspace.name: "${data.coder_workspace.me.name}"
    com.coder.user.id: "${data.coder_workspace.me.owner_id}"
    com.coder.user.username: "${data.coder_workspace.me.owner}"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: "${local.ns}"
  template:
    metadata:
      labels:
        app.kubernetes.io/name: "${local.ns}"
    spec:
      containers:
        - command:
            - bash
            - -c
            - "${coder_agent.main.init_script}"
          env:
            - name: CODER_PROC_MEMNICE_ENABLE
              value: "1"
            - name: CODER_AGENT_TOKEN
              value: "${coder_agent.main.token}"
          image: "${data.coder_parameter.docker_image.value}"
          imagePullPolicy: Always
          name: coder-agent
          securityContext:
            privileged: true
            runAsUser: 1000
      securityContext:
        fsGroup: 1000
        runAsUser: 1000