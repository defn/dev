analytics_settings(False)

load('ext://uibutton', 'cmd_button', 'location')

allow_k8s_contexts('pod')

local_resource('argocd', cmd = 'argocd app sync argocd --prune --local k/argocd', deps = ['k/argocd'])
