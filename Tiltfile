analytics_settings(False)

load('ext://uibutton', 'cmd_button', 'location')

allow_k8s_contexts('k3d-k3s-default')

k8s_yaml(".devcontainer/devcontainer.yaml")

cmd_button(name='vscode',
           argv=['code', '--folder-uri', 'vscode-remote://k8s-container+context=k3d-k3s-default+namespace=default+podname=dev-0+name=dev+/home/ubuntu'],
           text='Launch VSCode',
           location=location.NAV,
           icon_name='waving_hand')
