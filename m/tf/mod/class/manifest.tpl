apiVersion: apps/v1
kind: Deployment
metadata:
  name: "${ns}"
  namespace: default
  annotations:
    com.coder.user.email: "${owner_email}"
  labels:
    app.kubernetes.io/name: "${ns}"
    app.kubernetes.io/instance: "${ns}"
    app.kubernetes.io/part-of: "coder"
    com.coder.resource: "true"
    com.coder.workspace.id: "${id}"
    com.coder.workspace.name: "${name}"
    com.coder.user.id: "${owner_id}"
    com.coder.user.username: "${owner}"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: "${ns}"
  template:
    metadata:
      labels:
        app.kubernetes.io/name: "${ns}"
        kuma.io/sidecar-injection: enabled
      annotations:
        kuma.io/transparent-proxying-experimental-engine: enabled
    spec:
      serviceAccountName: "${ns}"
      containers:
        - command:
            - bash
            - -c
            - "echo ${init_script} | base64 -d | bash -"
          env:
            - name: CODER_PROC_MEMNICE_ENABLE
              value: "1"
            - name: CODER_AGENT_TOKEN
              value: "${token}"
          image: "${docker_image}"
          imagePullPolicy: Always
          name: coder-agent
          securityContext:
            privileged: true
            runAsUser: 1000
      securityContext:
        fsGroup: 1000
        runAsUser: 1000
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "${ns}"
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: "${ns}"
subjects:
- kind: ServiceAccount
  name: "${ns}"
  namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io