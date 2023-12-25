package y

res: namespace: "coder-amanibhavam-district0-cluster-argo-cd": cluster: argocd: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "argocd"
}
res: customresourcedefinition: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "applications.argoproj.io": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "applications.argoproj.io"
			"app.kubernetes.io/part-of": "argocd"
		}
		name: "applications.argoproj.io"
	}
	spec: {
		group: "argoproj.io"
		names: {
			kind:     "Application"
			listKind: "ApplicationList"
			plural:   "applications"
			shortNames: [
				"app",
				"apps",
			]
			singular: "application"
		}
		scope: "Namespaced"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".status.sync.status"
				name:     "Sync Status"
				type:     "string"
			}, {
				jsonPath: ".status.health.status"
				name:     "Health Status"
				type:     "string"
			}, {
				jsonPath: ".status.sync.revision"
				name:     "Revision"
				priority: 10
				type:     "string"
			}]
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "Application is a definition of Application resource."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					operation: {
						description: "Operation contains information about a requested or running operation"

						properties: {
							info: {
								description: "Info is a list of informational items for this operation"
								items: {
									properties: {
										name: type: "string"
										value: type: "string"
									}
									required: [
										"name",
										"value",
									]
									type: "object"
								}
								type: "array"
							}
							initiatedBy: {
								description: "InitiatedBy contains information about who initiated the operations"

								properties: {
									automated: {
										description: "Automated is set to true if operation was initiated automatically by the application controller."

										type: "boolean"
									}
									username: {
										description: "Username contains the name of a user who started operation"

										type: "string"
									}
								}
								type: "object"
							}
							retry: {
								description: "Retry controls the strategy to apply if a sync fails"
								properties: {
									backoff: {
										description: "Backoff controls how to backoff on subsequent retries of failed syncs"

										properties: {
											duration: {
												description: "Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. \"2m\", \"1h\")"

												type: "string"
											}
											factor: {
												description: "Factor is a factor to multiply the base duration after each failed retry"

												format: "int64"
												type:   "integer"
											}
											maxDuration: {
												description: "MaxDuration is the maximum amount of time allowed for the backoff strategy"

												type: "string"
											}
										}
										type: "object"
									}
									limit: {
										description: "Limit is the maximum number of attempts for retrying a failed sync. If set to 0, no retries will be performed."

										format: "int64"
										type:   "integer"
									}
								}
								type: "object"
							}
							sync: {
								description: "Sync contains parameters for the operation"
								properties: {
									dryRun: {
										description: "DryRun specifies to perform a `kubectl apply --dry-run` without actually performing the sync"

										type: "boolean"
									}
									manifests: {
										description: "Manifests is an optional field that overrides sync source with a local directory for development"

										items: type: "string"
										type: "array"
									}
									prune: {
										description: "Prune specifies to delete resources from the cluster that are no longer tracked in git"

										type: "boolean"
									}
									resources: {
										description: "Resources describes which resources shall be part of the sync"

										items: {
											description: "SyncOperationResource contains resources to sync."
											properties: {
												group: type: "string"
												kind: type: "string"
												name: type: "string"
												namespace: type: "string"
											}
											required: [
												"kind",
												"name",
											]
											type: "object"
										}
										type: "array"
									}
									revision: {
										description: "Revision is the revision (Git) or chart version (Helm) which to sync the application to If omitted, will use the revision specified in app spec."

										type: "string"
									}
									revisions: {
										description: "Revisions is the list of revision (Git) or chart version (Helm) which to sync each source in sources field for the application to If omitted, will use the revision specified in app spec."

										items: type: "string"
										type: "array"
									}
									source: {
										description: "Source overrides the source definition set in the application. This is typically set in a Rollback operation and is nil during a Sync operation"

										properties: {
											chart: {
												description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

												type: "string"
											}
											directory: {
												description: "Directory holds path/directory specific options"
												properties: {
													exclude: {
														description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

														type: "string"
													}
													include: {
														description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

														type: "string"
													}
													jsonnet: {
														description: "Jsonnet holds options specific to Jsonnet"
														properties: {
															extVars: {
																description: "ExtVars is a list of Jsonnet External Variables"

																items: {
																	description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																	properties: {
																		code: type: "boolean"
																		name: type: "string"
																		value: type: "string"
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
															libs: {
																description: "Additional library search dirs"
																items: type: "string"
																type: "array"
															}
															tlas: {
																description: "TLAS is a list of Jsonnet Top-level Arguments"
																items: {
																	description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																	properties: {
																		code: type: "boolean"
																		name: type: "string"
																		value: type: "string"
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
														}
														type: "object"
													}
													recurse: {
														description: "Recurse specifies whether to scan a directory recursively for manifests"

														type: "boolean"
													}
												}
												type: "object"
											}
											helm: {
												description: "Helm holds helm specific options"
												properties: {
													fileParameters: {
														description: "FileParameters are file parameters to the helm template"

														items: {
															description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

															properties: {
																name: {
																	description: "Name is the name of the Helm parameter"
																	type:        "string"
																}
																path: {
																	description: "Path is the path to the file containing the values for the Helm parameter"

																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
													ignoreMissingValueFiles: {
														description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

														type: "boolean"
													}
													parameters: {
														description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

														items: {
															description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

															properties: {
																forceString: {
																	description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																	type: "boolean"
																}
																name: {
																	description: "Name is the name of the Helm parameter"
																	type:        "string"
																}
																value: {
																	description: "Value is the value for the Helm parameter"
																	type:        "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
													passCredentials: {
														description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

														type: "boolean"
													}
													releaseName: {
														description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

														type: "string"
													}
													skipCrds: {
														description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

														type: "boolean"
													}
													valueFiles: {
														description: "ValuesFiles is a list of Helm value files to use when generating a template"

														items: type: "string"
														type: "array"
													}
													values: {
														description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

														type: "string"
													}
													valuesObject: {
														description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

														type:                                   "object"
														"x-kubernetes-preserve-unknown-fields": true
													}
													version: {
														description: "Version is the Helm version to use for templating (\"3\")"

														type: "string"
													}
												}
												type: "object"
											}
											kustomize: {
												description: "Kustomize holds kustomize specific options"
												properties: {
													commonAnnotations: {
														additionalProperties: type: "string"
														description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

														type: "object"
													}
													commonAnnotationsEnvsubst: {
														description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

														type: "boolean"
													}
													commonLabels: {
														additionalProperties: type: "string"
														description: "CommonLabels is a list of additional labels to add to rendered manifests"

														type: "object"
													}
													components: {
														description: "Components specifies a list of kustomize components to add to the kustomization before building"

														items: type: "string"
														type: "array"
													}
													forceCommonAnnotations: {
														description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

														type: "boolean"
													}
													forceCommonLabels: {
														description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

														type: "boolean"
													}
													images: {
														description: "Images is a list of Kustomize image override specifications"

														items: {
															description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

															type: "string"
														}
														type: "array"
													}
													namePrefix: {
														description: "NamePrefix is a prefix appended to resources for Kustomize apps"

														type: "string"
													}
													nameSuffix: {
														description: "NameSuffix is a suffix appended to resources for Kustomize apps"

														type: "string"
													}
													namespace: {
														description: "Namespace sets the namespace that Kustomize adds to all resources"

														type: "string"
													}
													patches: {
														description: "Patches is a list of Kustomize patches"
														items: {
															properties: {
																options: {
																	additionalProperties: type: "boolean"
																	type: "object"
																}
																patch: type: "string"
																path: type: "string"
																target: {
																	properties: {
																		annotationSelector: type: "string"
																		group: type: "string"
																		kind: type: "string"
																		labelSelector: type: "string"
																		name: type: "string"
																		namespace: type: "string"
																		version: type: "string"
																	}
																	type: "object"
																}
															}
															type: "object"
														}
														type: "array"
													}
													replicas: {
														description: "Replicas is a list of Kustomize Replicas override specifications"

														items: {
															properties: {
																count: {
																	anyOf: [{
																		type: "integer"
																	}, {
																		type: "string"
																	}]
																	description:                  "Number of replicas"
																	"x-kubernetes-int-or-string": true
																}
																name: {
																	description: "Name of Deployment or StatefulSet"
																	type:        "string"
																}
															}
															required: [
																"count",
																"name",
															]
															type: "object"
														}
														type: "array"
													}
													version: {
														description: "Version controls which version of Kustomize to use for rendering manifests"

														type: "string"
													}
												}
												type: "object"
											}
											path: {
												description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

												type: "string"
											}
											plugin: {
												description: "Plugin holds config management plugin specific options"

												properties: {
													env: {
														description: "Env is a list of environment variable entries"
														items: {
															description: "EnvEntry represents an entry in the application's environment"

															properties: {
																name: {
																	description: "Name is the name of the variable, usually expressed in uppercase"

																	type: "string"
																}
																value: {
																	description: "Value is the value of the variable"
																	type:        "string"
																}
															}
															required: [
																"name",
																"value",
															]
															type: "object"
														}
														type: "array"
													}
													name: type: "string"
													parameters: {
														items: {
															properties: {
																array: {
																	description: "Array is the value of an array type parameter."

																	items: type: "string"
																	type: "array"
																}
																map: {
																	additionalProperties: type: "string"
																	description: "Map is the value of a map type parameter."
																	type:        "object"
																}
																name: {
																	description: "Name is the name identifying a parameter."
																	type:        "string"
																}
																string: {
																	description: "String_ is the value of a string type parameter."

																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											ref: {
												description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

												type: "string"
											}
											repoURL: {
												description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

												type: "string"
											}
											targetRevision: {
												description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

												type: "string"
											}
										}
										required: ["repoURL"]
										type: "object"
									}
									sources: {
										description: "Sources overrides the source definition set in the application. This is typically set in a Rollback operation and is nil during a Sync operation"

										items: {
											description: "ApplicationSource contains all required information about the source of an application"

											properties: {
												chart: {
													description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

													type: "string"
												}
												directory: {
													description: "Directory holds path/directory specific options"
													properties: {
														exclude: {
															description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

															type: "string"
														}
														include: {
															description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

															type: "string"
														}
														jsonnet: {
															description: "Jsonnet holds options specific to Jsonnet"
															properties: {
																extVars: {
																	description: "ExtVars is a list of Jsonnet External Variables"

																	items: {
																		description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																		properties: {
																			code: type: "boolean"
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																libs: {
																	description: "Additional library search dirs"
																	items: type: "string"
																	type: "array"
																}
																tlas: {
																	description: "TLAS is a list of Jsonnet Top-level Arguments"

																	items: {
																		description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																		properties: {
																			code: type: "boolean"
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
															}
															type: "object"
														}
														recurse: {
															description: "Recurse specifies whether to scan a directory recursively for manifests"

															type: "boolean"
														}
													}
													type: "object"
												}
												helm: {
													description: "Helm holds helm specific options"
													properties: {
														fileParameters: {
															description: "FileParameters are file parameters to the helm template"

															items: {
																description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																properties: {
																	name: {
																		description: "Name is the name of the Helm parameter"
																		type:        "string"
																	}
																	path: {
																		description: "Path is the path to the file containing the values for the Helm parameter"

																		type: "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														ignoreMissingValueFiles: {
															description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

															type: "boolean"
														}
														parameters: {
															description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

															items: {
																description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																properties: {
																	forceString: {
																		description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																		type: "boolean"
																	}
																	name: {
																		description: "Name is the name of the Helm parameter"
																		type:        "string"
																	}
																	value: {
																		description: "Value is the value for the Helm parameter"
																		type:        "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														passCredentials: {
															description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

															type: "boolean"
														}
														releaseName: {
															description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

															type: "string"
														}
														skipCrds: {
															description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

															type: "boolean"
														}
														valueFiles: {
															description: "ValuesFiles is a list of Helm value files to use when generating a template"

															items: type: "string"
															type: "array"
														}
														values: {
															description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

															type: "string"
														}
														valuesObject: {
															description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

															type:                                   "object"
															"x-kubernetes-preserve-unknown-fields": true
														}
														version: {
															description: "Version is the Helm version to use for templating (\"3\")"

															type: "string"
														}
													}
													type: "object"
												}
												kustomize: {
													description: "Kustomize holds kustomize specific options"
													properties: {
														commonAnnotations: {
															additionalProperties: type: "string"
															description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

															type: "object"
														}
														commonAnnotationsEnvsubst: {
															description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

															type: "boolean"
														}
														commonLabels: {
															additionalProperties: type: "string"
															description: "CommonLabels is a list of additional labels to add to rendered manifests"

															type: "object"
														}
														components: {
															description: "Components specifies a list of kustomize components to add to the kustomization before building"

															items: type: "string"
															type: "array"
														}
														forceCommonAnnotations: {
															description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

															type: "boolean"
														}
														forceCommonLabels: {
															description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

															type: "boolean"
														}
														images: {
															description: "Images is a list of Kustomize image override specifications"

															items: {
																description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																type: "string"
															}
															type: "array"
														}
														namePrefix: {
															description: "NamePrefix is a prefix appended to resources for Kustomize apps"

															type: "string"
														}
														nameSuffix: {
															description: "NameSuffix is a suffix appended to resources for Kustomize apps"

															type: "string"
														}
														namespace: {
															description: "Namespace sets the namespace that Kustomize adds to all resources"

															type: "string"
														}
														patches: {
															description: "Patches is a list of Kustomize patches"
															items: {
																properties: {
																	options: {
																		additionalProperties: type: "boolean"
																		type: "object"
																	}
																	patch: type: "string"
																	path: type: "string"
																	target: {
																		properties: {
																			annotationSelector: type: "string"
																			group: type: "string"
																			kind: type: "string"
																			labelSelector: type: "string"
																			name: type: "string"
																			namespace: type: "string"
																			version: type: "string"
																		}
																		type: "object"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														replicas: {
															description: "Replicas is a list of Kustomize Replicas override specifications"

															items: {
																properties: {
																	count: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		description:                  "Number of replicas"
																		"x-kubernetes-int-or-string": true
																	}
																	name: {
																		description: "Name of Deployment or StatefulSet"
																		type:        "string"
																	}
																}
																required: [
																	"count",
																	"name",
																]
																type: "object"
															}
															type: "array"
														}
														version: {
															description: "Version controls which version of Kustomize to use for rendering manifests"

															type: "string"
														}
													}
													type: "object"
												}
												path: {
													description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

													type: "string"
												}
												plugin: {
													description: "Plugin holds config management plugin specific options"

													properties: {
														env: {
															description: "Env is a list of environment variable entries"
															items: {
																description: "EnvEntry represents an entry in the application's environment"

																properties: {
																	name: {
																		description: "Name is the name of the variable, usually expressed in uppercase"

																		type: "string"
																	}
																	value: {
																		description: "Value is the value of the variable"
																		type:        "string"
																	}
																}
																required: [
																	"name",
																	"value",
																]
																type: "object"
															}
															type: "array"
														}
														name: type: "string"
														parameters: {
															items: {
																properties: {
																	array: {
																		description: "Array is the value of an array type parameter."

																		items: type: "string"
																		type: "array"
																	}
																	map: {
																		additionalProperties: type: "string"
																		description: "Map is the value of a map type parameter."
																		type:        "object"
																	}
																	name: {
																		description: "Name is the name identifying a parameter."
																		type:        "string"
																	}
																	string: {
																		description: "String_ is the value of a string type parameter."

																		type: "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
													}
													type: "object"
												}
												ref: {
													description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

													type: "string"
												}
												repoURL: {
													description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

													type: "string"
												}
												targetRevision: {
													description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

													type: "string"
												}
											}
											required: ["repoURL"]
											type: "object"
										}
										type: "array"
									}
									syncOptions: {
										description: "SyncOptions provide per-sync sync-options, e.g. Validate=false"
										items: type: "string"
										type: "array"
									}
									syncStrategy: {
										description: "SyncStrategy describes how to perform the sync"
										properties: {
											apply: {
												description: "Apply will perform a `kubectl apply` to perform the sync."

												properties: force: {
													description: "Force indicates whether or not to supply the --force flag to `kubectl apply`. The --force flag deletes and re-create the resource, when PATCH encounters conflict and has retried for 5 times."

													type: "boolean"
												}
												type: "object"
											}
											hook: {
												description: "Hook will submit any referenced resources to perform the sync. This is the default strategy"

												properties: force: {
													description: "Force indicates whether or not to supply the --force flag to `kubectl apply`. The --force flag deletes and re-create the resource, when PATCH encounters conflict and has retried for 5 times."

													type: "boolean"
												}
												type: "object"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
						}
						type: "object"
					}
					spec: {
						description: "ApplicationSpec represents desired application state. Contains link to repository with application definition and additional parameters link definition revision."

						properties: {
							destination: {
								description: "Destination is a reference to the target Kubernetes server and namespace"

								properties: {
									name: {
										description: "Name is an alternate way of specifying the target cluster by its symbolic name. This must be set if Server is not set."

										type: "string"
									}
									namespace: {
										description: "Namespace specifies the target namespace for the application's resources. The namespace will only be set for namespace-scoped resources that have not set a value for .metadata.namespace"

										type: "string"
									}
									server: {
										description: "Server specifies the URL of the target cluster's Kubernetes control plane API. This must be set if Name is not set."

										type: "string"
									}
								}
								type: "object"
							}
							ignoreDifferences: {
								description: "IgnoreDifferences is a list of resources and their fields which should be ignored during comparison"

								items: {
									description: "ResourceIgnoreDifferences contains resource filter and list of json paths which should be ignored during comparison with live state."

									properties: {
										group: type: "string"
										jqPathExpressions: {
											items: type: "string"
											type: "array"
										}
										jsonPointers: {
											items: type: "string"
											type: "array"
										}
										kind: type: "string"
										managedFieldsManagers: {
											description: "ManagedFieldsManagers is a list of trusted managers. Fields mutated by those managers will take precedence over the desired state defined in the SCM and won't be displayed in diffs"

											items: type: "string"
											type: "array"
										}
										name: type: "string"
										namespace: type: "string"
									}
									required: ["kind"]
									type: "object"
								}
								type: "array"
							}
							info: {
								description: "Info contains a list of information (URLs, email addresses, and plain text) that relates to the application"

								items: {
									properties: {
										name: type: "string"
										value: type: "string"
									}
									required: [
										"name",
										"value",
									]
									type: "object"
								}
								type: "array"
							}
							project: {
								description: "Project is a reference to the project this application belongs to. The empty string means that application belongs to the 'default' project."

								type: "string"
							}
							revisionHistoryLimit: {
								description: "RevisionHistoryLimit limits the number of items kept in the application's revision history, which is used for informational purposes as well as for rollbacks to previous versions. This should only be changed in exceptional circumstances. Setting to zero will store no history. This will reduce storage used. Increasing will increase the space used to store the history, so we do not recommend increasing it. Default is 10."

								format: "int64"
								type:   "integer"
							}
							source: {
								description: "Source is a reference to the location of the application's manifests or chart"

								properties: {
									chart: {
										description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

										type: "string"
									}
									directory: {
										description: "Directory holds path/directory specific options"
										properties: {
											exclude: {
												description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

												type: "string"
											}
											include: {
												description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

												type: "string"
											}
											jsonnet: {
												description: "Jsonnet holds options specific to Jsonnet"
												properties: {
													extVars: {
														description: "ExtVars is a list of Jsonnet External Variables"
														items: {
															description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

															properties: {
																code: type: "boolean"
																name: type: "string"
																value: type: "string"
															}
															required: [
																"name",
																"value",
															]
															type: "object"
														}
														type: "array"
													}
													libs: {
														description: "Additional library search dirs"
														items: type: "string"
														type: "array"
													}
													tlas: {
														description: "TLAS is a list of Jsonnet Top-level Arguments"
														items: {
															description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

															properties: {
																code: type: "boolean"
																name: type: "string"
																value: type: "string"
															}
															required: [
																"name",
																"value",
															]
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											recurse: {
												description: "Recurse specifies whether to scan a directory recursively for manifests"

												type: "boolean"
											}
										}
										type: "object"
									}
									helm: {
										description: "Helm holds helm specific options"
										properties: {
											fileParameters: {
												description: "FileParameters are file parameters to the helm template"

												items: {
													description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

													properties: {
														name: {
															description: "Name is the name of the Helm parameter"
															type:        "string"
														}
														path: {
															description: "Path is the path to the file containing the values for the Helm parameter"

															type: "string"
														}
													}
													type: "object"
												}
												type: "array"
											}
											ignoreMissingValueFiles: {
												description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

												type: "boolean"
											}
											parameters: {
												description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

												items: {
													description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

													properties: {
														forceString: {
															description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

															type: "boolean"
														}
														name: {
															description: "Name is the name of the Helm parameter"
															type:        "string"
														}
														value: {
															description: "Value is the value for the Helm parameter"
															type:        "string"
														}
													}
													type: "object"
												}
												type: "array"
											}
											passCredentials: {
												description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

												type: "boolean"
											}
											releaseName: {
												description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

												type: "string"
											}
											skipCrds: {
												description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

												type: "boolean"
											}
											valueFiles: {
												description: "ValuesFiles is a list of Helm value files to use when generating a template"

												items: type: "string"
												type: "array"
											}
											values: {
												description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

												type: "string"
											}
											valuesObject: {
												description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

												type:                                   "object"
												"x-kubernetes-preserve-unknown-fields": true
											}
											version: {
												description: "Version is the Helm version to use for templating (\"3\")"

												type: "string"
											}
										}
										type: "object"
									}
									kustomize: {
										description: "Kustomize holds kustomize specific options"
										properties: {
											commonAnnotations: {
												additionalProperties: type: "string"
												description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

												type: "object"
											}
											commonAnnotationsEnvsubst: {
												description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

												type: "boolean"
											}
											commonLabels: {
												additionalProperties: type: "string"
												description: "CommonLabels is a list of additional labels to add to rendered manifests"

												type: "object"
											}
											components: {
												description: "Components specifies a list of kustomize components to add to the kustomization before building"

												items: type: "string"
												type: "array"
											}
											forceCommonAnnotations: {
												description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

												type: "boolean"
											}
											forceCommonLabels: {
												description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

												type: "boolean"
											}
											images: {
												description: "Images is a list of Kustomize image override specifications"

												items: {
													description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

													type: "string"
												}
												type: "array"
											}
											namePrefix: {
												description: "NamePrefix is a prefix appended to resources for Kustomize apps"

												type: "string"
											}
											nameSuffix: {
												description: "NameSuffix is a suffix appended to resources for Kustomize apps"

												type: "string"
											}
											namespace: {
												description: "Namespace sets the namespace that Kustomize adds to all resources"

												type: "string"
											}
											patches: {
												description: "Patches is a list of Kustomize patches"
												items: {
													properties: {
														options: {
															additionalProperties: type: "boolean"
															type: "object"
														}
														patch: type: "string"
														path: type: "string"
														target: {
															properties: {
																annotationSelector: type: "string"
																group: type: "string"
																kind: type: "string"
																labelSelector: type: "string"
																name: type: "string"
																namespace: type: "string"
																version: type: "string"
															}
															type: "object"
														}
													}
													type: "object"
												}
												type: "array"
											}
											replicas: {
												description: "Replicas is a list of Kustomize Replicas override specifications"

												items: {
													properties: {
														count: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															description:                  "Number of replicas"
															"x-kubernetes-int-or-string": true
														}
														name: {
															description: "Name of Deployment or StatefulSet"
															type:        "string"
														}
													}
													required: [
														"count",
														"name",
													]
													type: "object"
												}
												type: "array"
											}
											version: {
												description: "Version controls which version of Kustomize to use for rendering manifests"

												type: "string"
											}
										}
										type: "object"
									}
									path: {
										description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

										type: "string"
									}
									plugin: {
										description: "Plugin holds config management plugin specific options"
										properties: {
											env: {
												description: "Env is a list of environment variable entries"
												items: {
													description: "EnvEntry represents an entry in the application's environment"

													properties: {
														name: {
															description: "Name is the name of the variable, usually expressed in uppercase"

															type: "string"
														}
														value: {
															description: "Value is the value of the variable"
															type:        "string"
														}
													}
													required: [
														"name",
														"value",
													]
													type: "object"
												}
												type: "array"
											}
											name: type: "string"
											parameters: {
												items: {
													properties: {
														array: {
															description: "Array is the value of an array type parameter."
															items: type: "string"
															type: "array"
														}
														map: {
															additionalProperties: type: "string"
															description: "Map is the value of a map type parameter."
															type:        "object"
														}
														name: {
															description: "Name is the name identifying a parameter."
															type:        "string"
														}
														string: {
															description: "String_ is the value of a string type parameter."
															type:        "string"
														}
													}
													type: "object"
												}
												type: "array"
											}
										}
										type: "object"
									}
									ref: {
										description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

										type: "string"
									}
									repoURL: {
										description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

										type: "string"
									}
									targetRevision: {
										description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

										type: "string"
									}
								}
								required: ["repoURL"]
								type: "object"
							}
							sources: {
								description: "Sources is a reference to the location of the application's manifests or chart"

								items: {
									description: "ApplicationSource contains all required information about the source of an application"

									properties: {
										chart: {
											description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

											type: "string"
										}
										directory: {
											description: "Directory holds path/directory specific options"
											properties: {
												exclude: {
													description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

													type: "string"
												}
												include: {
													description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

													type: "string"
												}
												jsonnet: {
													description: "Jsonnet holds options specific to Jsonnet"
													properties: {
														extVars: {
															description: "ExtVars is a list of Jsonnet External Variables"
															items: {
																description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																properties: {
																	code: type: "boolean"
																	name: type: "string"
																	value: type: "string"
																}
																required: [
																	"name",
																	"value",
																]
																type: "object"
															}
															type: "array"
														}
														libs: {
															description: "Additional library search dirs"
															items: type: "string"
															type: "array"
														}
														tlas: {
															description: "TLAS is a list of Jsonnet Top-level Arguments"
															items: {
																description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																properties: {
																	code: type: "boolean"
																	name: type: "string"
																	value: type: "string"
																}
																required: [
																	"name",
																	"value",
																]
																type: "object"
															}
															type: "array"
														}
													}
													type: "object"
												}
												recurse: {
													description: "Recurse specifies whether to scan a directory recursively for manifests"

													type: "boolean"
												}
											}
											type: "object"
										}
										helm: {
											description: "Helm holds helm specific options"
											properties: {
												fileParameters: {
													description: "FileParameters are file parameters to the helm template"

													items: {
														description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

														properties: {
															name: {
																description: "Name is the name of the Helm parameter"
																type:        "string"
															}
															path: {
																description: "Path is the path to the file containing the values for the Helm parameter"

																type: "string"
															}
														}
														type: "object"
													}
													type: "array"
												}
												ignoreMissingValueFiles: {
													description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

													type: "boolean"
												}
												parameters: {
													description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

													items: {
														description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

														properties: {
															forceString: {
																description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																type: "boolean"
															}
															name: {
																description: "Name is the name of the Helm parameter"
																type:        "string"
															}
															value: {
																description: "Value is the value for the Helm parameter"
																type:        "string"
															}
														}
														type: "object"
													}
													type: "array"
												}
												passCredentials: {
													description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

													type: "boolean"
												}
												releaseName: {
													description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

													type: "string"
												}
												skipCrds: {
													description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

													type: "boolean"
												}
												valueFiles: {
													description: "ValuesFiles is a list of Helm value files to use when generating a template"

													items: type: "string"
													type: "array"
												}
												values: {
													description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

													type: "string"
												}
												valuesObject: {
													description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

													type:                                   "object"
													"x-kubernetes-preserve-unknown-fields": true
												}
												version: {
													description: "Version is the Helm version to use for templating (\"3\")"

													type: "string"
												}
											}
											type: "object"
										}
										kustomize: {
											description: "Kustomize holds kustomize specific options"
											properties: {
												commonAnnotations: {
													additionalProperties: type: "string"
													description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

													type: "object"
												}
												commonAnnotationsEnvsubst: {
													description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

													type: "boolean"
												}
												commonLabels: {
													additionalProperties: type: "string"
													description: "CommonLabels is a list of additional labels to add to rendered manifests"

													type: "object"
												}
												components: {
													description: "Components specifies a list of kustomize components to add to the kustomization before building"

													items: type: "string"
													type: "array"
												}
												forceCommonAnnotations: {
													description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

													type: "boolean"
												}
												forceCommonLabels: {
													description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

													type: "boolean"
												}
												images: {
													description: "Images is a list of Kustomize image override specifications"

													items: {
														description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

														type: "string"
													}
													type: "array"
												}
												namePrefix: {
													description: "NamePrefix is a prefix appended to resources for Kustomize apps"

													type: "string"
												}
												nameSuffix: {
													description: "NameSuffix is a suffix appended to resources for Kustomize apps"

													type: "string"
												}
												namespace: {
													description: "Namespace sets the namespace that Kustomize adds to all resources"

													type: "string"
												}
												patches: {
													description: "Patches is a list of Kustomize patches"
													items: {
														properties: {
															options: {
																additionalProperties: type: "boolean"
																type: "object"
															}
															patch: type: "string"
															path: type: "string"
															target: {
																properties: {
																	annotationSelector: type: "string"
																	group: type: "string"
																	kind: type: "string"
																	labelSelector: type: "string"
																	name: type: "string"
																	namespace: type: "string"
																	version: type: "string"
																}
																type: "object"
															}
														}
														type: "object"
													}
													type: "array"
												}
												replicas: {
													description: "Replicas is a list of Kustomize Replicas override specifications"

													items: {
														properties: {
															count: {
																anyOf: [{
																	type: "integer"
																}, {
																	type: "string"
																}]
																description:                  "Number of replicas"
																"x-kubernetes-int-or-string": true
															}
															name: {
																description: "Name of Deployment or StatefulSet"
																type:        "string"
															}
														}
														required: [
															"count",
															"name",
														]
														type: "object"
													}
													type: "array"
												}
												version: {
													description: "Version controls which version of Kustomize to use for rendering manifests"

													type: "string"
												}
											}
											type: "object"
										}
										path: {
											description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

											type: "string"
										}
										plugin: {
											description: "Plugin holds config management plugin specific options"

											properties: {
												env: {
													description: "Env is a list of environment variable entries"
													items: {
														description: "EnvEntry represents an entry in the application's environment"

														properties: {
															name: {
																description: "Name is the name of the variable, usually expressed in uppercase"

																type: "string"
															}
															value: {
																description: "Value is the value of the variable"
																type:        "string"
															}
														}
														required: [
															"name",
															"value",
														]
														type: "object"
													}
													type: "array"
												}
												name: type: "string"
												parameters: {
													items: {
														properties: {
															array: {
																description: "Array is the value of an array type parameter."
																items: type: "string"
																type: "array"
															}
															map: {
																additionalProperties: type: "string"
																description: "Map is the value of a map type parameter."
																type:        "object"
															}
															name: {
																description: "Name is the name identifying a parameter."
																type:        "string"
															}
															string: {
																description: "String_ is the value of a string type parameter."

																type: "string"
															}
														}
														type: "object"
													}
													type: "array"
												}
											}
											type: "object"
										}
										ref: {
											description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

											type: "string"
										}
										repoURL: {
											description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

											type: "string"
										}
										targetRevision: {
											description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

											type: "string"
										}
									}
									required: ["repoURL"]
									type: "object"
								}
								type: "array"
							}
							syncPolicy: {
								description: "SyncPolicy controls when and how a sync will be performed"
								properties: {
									automated: {
										description: "Automated will keep an application synced to the target revision"

										properties: {
											allowEmpty: {
												description: "AllowEmpty allows apps have zero live resources (default: false)"

												type: "boolean"
											}
											prune: {
												description: "Prune specifies whether to delete resources from the cluster that are not found in the sources anymore as part of automated sync (default: false)"

												type: "boolean"
											}
											selfHeal: {
												description: "SelfHeal specifies whether to revert resources back to their desired state upon modification in the cluster (default: false)"

												type: "boolean"
											}
										}
										type: "object"
									}
									managedNamespaceMetadata: {
										description: "ManagedNamespaceMetadata controls metadata in the given namespace (if CreateNamespace=true)"

										properties: {
											annotations: {
												additionalProperties: type: "string"
												type: "object"
											}
											labels: {
												additionalProperties: type: "string"
												type: "object"
											}
										}
										type: "object"
									}
									retry: {
										description: "Retry controls failed sync retry behavior"
										properties: {
											backoff: {
												description: "Backoff controls how to backoff on subsequent retries of failed syncs"

												properties: {
													duration: {
														description: "Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. \"2m\", \"1h\")"

														type: "string"
													}
													factor: {
														description: "Factor is a factor to multiply the base duration after each failed retry"

														format: "int64"
														type:   "integer"
													}
													maxDuration: {
														description: "MaxDuration is the maximum amount of time allowed for the backoff strategy"

														type: "string"
													}
												}
												type: "object"
											}
											limit: {
												description: "Limit is the maximum number of attempts for retrying a failed sync. If set to 0, no retries will be performed."

												format: "int64"
												type:   "integer"
											}
										}
										type: "object"
									}
									syncOptions: {
										description: "Options allow you to specify whole app sync-options"
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
						}
						required: [
							"destination",
							"project",
						]
						type: "object"
					}
					status: {
						description: "ApplicationStatus contains status information for the application"
						properties: {
							conditions: {
								description: "Conditions is a list of currently observed application conditions"

								items: {
									description: "ApplicationCondition contains details about an application condition, which is usually an error or warning"

									properties: {
										lastTransitionTime: {
											description: "LastTransitionTime is the time the condition was last observed"

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "Message contains human-readable message indicating details about condition"

											type: "string"
										}
										type: {
											description: "Type is an application condition type"
											type:        "string"
										}
									}
									required: [
										"message",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							controllerNamespace: {
								description: "ControllerNamespace indicates the namespace in which the application controller is located"

								type: "string"
							}
							health: {
								description: "Health contains information about the application's current health status"

								properties: {
									message: {
										description: "Message is a human-readable informational message describing the health status"

										type: "string"
									}
									status: {
										description: "Status holds the status code of the application or resource"

										type: "string"
									}
								}
								type: "object"
							}
							history: {
								description: "History contains information about the application's sync history"

								items: {
									description: "RevisionHistory contains history information about a previous sync"

									properties: {
										deployStartedAt: {
											description: "DeployStartedAt holds the time the sync operation started"

											format: "date-time"
											type:   "string"
										}
										deployedAt: {
											description: "DeployedAt holds the time the sync operation completed"
											format:      "date-time"
											type:        "string"
										}
										id: {
											description: "ID is an auto incrementing identifier of the RevisionHistory"
											format:      "int64"
											type:        "integer"
										}
										revision: {
											description: "Revision holds the revision the sync was performed against"

											type: "string"
										}
										revisions: {
											description: "Revisions holds the revision of each source in sources field the sync was performed against"

											items: type: "string"
											type: "array"
										}
										source: {
											description: "Source is a reference to the application source used for the sync operation"

											properties: {
												chart: {
													description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

													type: "string"
												}
												directory: {
													description: "Directory holds path/directory specific options"
													properties: {
														exclude: {
															description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

															type: "string"
														}
														include: {
															description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

															type: "string"
														}
														jsonnet: {
															description: "Jsonnet holds options specific to Jsonnet"
															properties: {
																extVars: {
																	description: "ExtVars is a list of Jsonnet External Variables"

																	items: {
																		description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																		properties: {
																			code: type: "boolean"
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																libs: {
																	description: "Additional library search dirs"
																	items: type: "string"
																	type: "array"
																}
																tlas: {
																	description: "TLAS is a list of Jsonnet Top-level Arguments"

																	items: {
																		description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																		properties: {
																			code: type: "boolean"
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
															}
															type: "object"
														}
														recurse: {
															description: "Recurse specifies whether to scan a directory recursively for manifests"

															type: "boolean"
														}
													}
													type: "object"
												}
												helm: {
													description: "Helm holds helm specific options"
													properties: {
														fileParameters: {
															description: "FileParameters are file parameters to the helm template"

															items: {
																description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																properties: {
																	name: {
																		description: "Name is the name of the Helm parameter"
																		type:        "string"
																	}
																	path: {
																		description: "Path is the path to the file containing the values for the Helm parameter"

																		type: "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														ignoreMissingValueFiles: {
															description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

															type: "boolean"
														}
														parameters: {
															description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

															items: {
																description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																properties: {
																	forceString: {
																		description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																		type: "boolean"
																	}
																	name: {
																		description: "Name is the name of the Helm parameter"
																		type:        "string"
																	}
																	value: {
																		description: "Value is the value for the Helm parameter"
																		type:        "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														passCredentials: {
															description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

															type: "boolean"
														}
														releaseName: {
															description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

															type: "string"
														}
														skipCrds: {
															description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

															type: "boolean"
														}
														valueFiles: {
															description: "ValuesFiles is a list of Helm value files to use when generating a template"

															items: type: "string"
															type: "array"
														}
														values: {
															description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

															type: "string"
														}
														valuesObject: {
															description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

															type:                                   "object"
															"x-kubernetes-preserve-unknown-fields": true
														}
														version: {
															description: "Version is the Helm version to use for templating (\"3\")"

															type: "string"
														}
													}
													type: "object"
												}
												kustomize: {
													description: "Kustomize holds kustomize specific options"
													properties: {
														commonAnnotations: {
															additionalProperties: type: "string"
															description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

															type: "object"
														}
														commonAnnotationsEnvsubst: {
															description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

															type: "boolean"
														}
														commonLabels: {
															additionalProperties: type: "string"
															description: "CommonLabels is a list of additional labels to add to rendered manifests"

															type: "object"
														}
														components: {
															description: "Components specifies a list of kustomize components to add to the kustomization before building"

															items: type: "string"
															type: "array"
														}
														forceCommonAnnotations: {
															description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

															type: "boolean"
														}
														forceCommonLabels: {
															description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

															type: "boolean"
														}
														images: {
															description: "Images is a list of Kustomize image override specifications"

															items: {
																description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																type: "string"
															}
															type: "array"
														}
														namePrefix: {
															description: "NamePrefix is a prefix appended to resources for Kustomize apps"

															type: "string"
														}
														nameSuffix: {
															description: "NameSuffix is a suffix appended to resources for Kustomize apps"

															type: "string"
														}
														namespace: {
															description: "Namespace sets the namespace that Kustomize adds to all resources"

															type: "string"
														}
														patches: {
															description: "Patches is a list of Kustomize patches"
															items: {
																properties: {
																	options: {
																		additionalProperties: type: "boolean"
																		type: "object"
																	}
																	patch: type: "string"
																	path: type: "string"
																	target: {
																		properties: {
																			annotationSelector: type: "string"
																			group: type: "string"
																			kind: type: "string"
																			labelSelector: type: "string"
																			name: type: "string"
																			namespace: type: "string"
																			version: type: "string"
																		}
																		type: "object"
																	}
																}
																type: "object"
															}
															type: "array"
														}
														replicas: {
															description: "Replicas is a list of Kustomize Replicas override specifications"

															items: {
																properties: {
																	count: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		description:                  "Number of replicas"
																		"x-kubernetes-int-or-string": true
																	}
																	name: {
																		description: "Name of Deployment or StatefulSet"
																		type:        "string"
																	}
																}
																required: [
																	"count",
																	"name",
																]
																type: "object"
															}
															type: "array"
														}
														version: {
															description: "Version controls which version of Kustomize to use for rendering manifests"

															type: "string"
														}
													}
													type: "object"
												}
												path: {
													description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

													type: "string"
												}
												plugin: {
													description: "Plugin holds config management plugin specific options"

													properties: {
														env: {
															description: "Env is a list of environment variable entries"
															items: {
																description: "EnvEntry represents an entry in the application's environment"

																properties: {
																	name: {
																		description: "Name is the name of the variable, usually expressed in uppercase"

																		type: "string"
																	}
																	value: {
																		description: "Value is the value of the variable"
																		type:        "string"
																	}
																}
																required: [
																	"name",
																	"value",
																]
																type: "object"
															}
															type: "array"
														}
														name: type: "string"
														parameters: {
															items: {
																properties: {
																	array: {
																		description: "Array is the value of an array type parameter."

																		items: type: "string"
																		type: "array"
																	}
																	map: {
																		additionalProperties: type: "string"
																		description: "Map is the value of a map type parameter."
																		type:        "object"
																	}
																	name: {
																		description: "Name is the name identifying a parameter."
																		type:        "string"
																	}
																	string: {
																		description: "String_ is the value of a string type parameter."

																		type: "string"
																	}
																}
																type: "object"
															}
															type: "array"
														}
													}
													type: "object"
												}
												ref: {
													description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

													type: "string"
												}
												repoURL: {
													description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

													type: "string"
												}
												targetRevision: {
													description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

													type: "string"
												}
											}
											required: ["repoURL"]
											type: "object"
										}
										sources: {
											description: "Sources is a reference to the application sources used for the sync operation"

											items: {
												description: "ApplicationSource contains all required information about the source of an application"

												properties: {
													chart: {
														description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

														type: "string"
													}
													directory: {
														description: "Directory holds path/directory specific options"
														properties: {
															exclude: {
																description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																type: "string"
															}
															include: {
																description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																type: "string"
															}
															jsonnet: {
																description: "Jsonnet holds options specific to Jsonnet"
																properties: {
																	extVars: {
																		description: "ExtVars is a list of Jsonnet External Variables"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	libs: {
																		description: "Additional library search dirs"
																		items: type: "string"
																		type: "array"
																	}
																	tlas: {
																		description: "TLAS is a list of Jsonnet Top-level Arguments"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																}
																type: "object"
															}
															recurse: {
																description: "Recurse specifies whether to scan a directory recursively for manifests"

																type: "boolean"
															}
														}
														type: "object"
													}
													helm: {
														description: "Helm holds helm specific options"
														properties: {
															fileParameters: {
																description: "FileParameters are file parameters to the helm template"

																items: {
																	description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																	properties: {
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		path: {
																			description: "Path is the path to the file containing the values for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															ignoreMissingValueFiles: {
																description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																type: "boolean"
															}
															parameters: {
																description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																items: {
																	description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																	properties: {
																		forceString: {
																			description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																			type: "boolean"
																		}
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		value: {
																			description: "Value is the value for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															passCredentials: {
																description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																type: "boolean"
															}
															releaseName: {
																description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																type: "string"
															}
															skipCrds: {
																description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																type: "boolean"
															}
															valueFiles: {
																description: "ValuesFiles is a list of Helm value files to use when generating a template"

																items: type: "string"
																type: "array"
															}
															values: {
																description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																type: "string"
															}
															valuesObject: {
																description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																type:                                   "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															version: {
																description: "Version is the Helm version to use for templating (\"3\")"

																type: "string"
															}
														}
														type: "object"
													}
													kustomize: {
														description: "Kustomize holds kustomize specific options"
														properties: {
															commonAnnotations: {
																additionalProperties: type: "string"
																description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																type: "object"
															}
															commonAnnotationsEnvsubst: {
																description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																type: "boolean"
															}
															commonLabels: {
																additionalProperties: type: "string"
																description: "CommonLabels is a list of additional labels to add to rendered manifests"

																type: "object"
															}
															components: {
																description: "Components specifies a list of kustomize components to add to the kustomization before building"

																items: type: "string"
																type: "array"
															}
															forceCommonAnnotations: {
																description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																type: "boolean"
															}
															forceCommonLabels: {
																description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																type: "boolean"
															}
															images: {
																description: "Images is a list of Kustomize image override specifications"

																items: {
																	description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																	type: "string"
																}
																type: "array"
															}
															namePrefix: {
																description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																type: "string"
															}
															nameSuffix: {
																description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																type: "string"
															}
															namespace: {
																description: "Namespace sets the namespace that Kustomize adds to all resources"

																type: "string"
															}
															patches: {
																description: "Patches is a list of Kustomize patches"
																items: {
																	properties: {
																		options: {
																			additionalProperties: type: "boolean"
																			type: "object"
																		}
																		patch: type: "string"
																		path: type: "string"
																		target: {
																			properties: {
																				annotationSelector: type: "string"
																				group: type: "string"
																				kind: type: "string"
																				labelSelector: type: "string"
																				name: type: "string"
																				namespace: type: "string"
																				version: type: "string"
																			}
																			type: "object"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															replicas: {
																description: "Replicas is a list of Kustomize Replicas override specifications"

																items: {
																	properties: {
																		count: {
																			anyOf: [{
																				type: "integer"
																			}, {
																				type: "string"
																			}]
																			description:                  "Number of replicas"
																			"x-kubernetes-int-or-string": true
																		}
																		name: {
																			description: "Name of Deployment or StatefulSet"
																			type:        "string"
																		}
																	}
																	required: [
																		"count",
																		"name",
																	]
																	type: "object"
																}
																type: "array"
															}
															version: {
																description: "Version controls which version of Kustomize to use for rendering manifests"

																type: "string"
															}
														}
														type: "object"
													}
													path: {
														description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

														type: "string"
													}
													plugin: {
														description: "Plugin holds config management plugin specific options"

														properties: {
															env: {
																description: "Env is a list of environment variable entries"

																items: {
																	description: "EnvEntry represents an entry in the application's environment"

																	properties: {
																		name: {
																			description: "Name is the name of the variable, usually expressed in uppercase"

																			type: "string"
																		}
																		value: {
																			description: "Value is the value of the variable"
																			type:        "string"
																		}
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
															name: type: "string"
															parameters: {
																items: {
																	properties: {
																		array: {
																			description: "Array is the value of an array type parameter."

																			items: type: "string"
																			type: "array"
																		}
																		map: {
																			additionalProperties: type: "string"
																			description: "Map is the value of a map type parameter."

																			type: "object"
																		}
																		name: {
																			description: "Name is the name identifying a parameter."

																			type: "string"
																		}
																		string: {
																			description: "String_ is the value of a string type parameter."

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
														}
														type: "object"
													}
													ref: {
														description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

														type: "string"
													}
													repoURL: {
														description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

														type: "string"
													}
													targetRevision: {
														description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

														type: "string"
													}
												}
												required: ["repoURL"]
												type: "object"
											}
											type: "array"
										}
									}
									required: [
										"deployedAt",
										"id",
									]
									type: "object"
								}
								type: "array"
							}
							observedAt: {
								description: "ObservedAt indicates when the application state was updated without querying latest git state Deprecated: controller no longer updates ObservedAt field"

								format: "date-time"
								type:   "string"
							}
							operationState: {
								description: "OperationState contains information about any ongoing operations, such as a sync"

								properties: {
									finishedAt: {
										description: "FinishedAt contains time of operation completion"
										format:      "date-time"
										type:        "string"
									}
									message: {
										description: "Message holds any pertinent messages when attempting to perform operation (typically errors)."

										type: "string"
									}
									operation: {
										description: "Operation is the original requested operation"
										properties: {
											info: {
												description: "Info is a list of informational items for this operation"

												items: {
													properties: {
														name: type: "string"
														value: type: "string"
													}
													required: [
														"name",
														"value",
													]
													type: "object"
												}
												type: "array"
											}
											initiatedBy: {
												description: "InitiatedBy contains information about who initiated the operations"

												properties: {
													automated: {
														description: "Automated is set to true if operation was initiated automatically by the application controller."

														type: "boolean"
													}
													username: {
														description: "Username contains the name of a user who started operation"

														type: "string"
													}
												}
												type: "object"
											}
											retry: {
												description: "Retry controls the strategy to apply if a sync fails"

												properties: {
													backoff: {
														description: "Backoff controls how to backoff on subsequent retries of failed syncs"

														properties: {
															duration: {
																description: "Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. \"2m\", \"1h\")"

																type: "string"
															}
															factor: {
																description: "Factor is a factor to multiply the base duration after each failed retry"

																format: "int64"
																type:   "integer"
															}
															maxDuration: {
																description: "MaxDuration is the maximum amount of time allowed for the backoff strategy"

																type: "string"
															}
														}
														type: "object"
													}
													limit: {
														description: "Limit is the maximum number of attempts for retrying a failed sync. If set to 0, no retries will be performed."

														format: "int64"
														type:   "integer"
													}
												}
												type: "object"
											}
											sync: {
												description: "Sync contains parameters for the operation"
												properties: {
													dryRun: {
														description: "DryRun specifies to perform a `kubectl apply --dry-run` without actually performing the sync"

														type: "boolean"
													}
													manifests: {
														description: "Manifests is an optional field that overrides sync source with a local directory for development"

														items: type: "string"
														type: "array"
													}
													prune: {
														description: "Prune specifies to delete resources from the cluster that are no longer tracked in git"

														type: "boolean"
													}
													resources: {
														description: "Resources describes which resources shall be part of the sync"

														items: {
															description: "SyncOperationResource contains resources to sync."

															properties: {
																group: type: "string"
																kind: type: "string"
																name: type: "string"
																namespace: type: "string"
															}
															required: [
																"kind",
																"name",
															]
															type: "object"
														}
														type: "array"
													}
													revision: {
														description: "Revision is the revision (Git) or chart version (Helm) which to sync the application to If omitted, will use the revision specified in app spec."

														type: "string"
													}
													revisions: {
														description: "Revisions is the list of revision (Git) or chart version (Helm) which to sync each source in sources field for the application to If omitted, will use the revision specified in app spec."

														items: type: "string"
														type: "array"
													}
													source: {
														description: "Source overrides the source definition set in the application. This is typically set in a Rollback operation and is nil during a Sync operation"

														properties: {
															chart: {
																description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

																type: "string"
															}
															directory: {
																description: "Directory holds path/directory specific options"

																properties: {
																	exclude: {
																		description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																		type: "string"
																	}
																	include: {
																		description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																		type: "string"
																	}
																	jsonnet: {
																		description: "Jsonnet holds options specific to Jsonnet"

																		properties: {
																			extVars: {
																				description: "ExtVars is a list of Jsonnet External Variables"

																				items: {
																					description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																					properties: {
																						code: type: "boolean"
																						name: type: "string"
																						value: type: "string"
																					}
																					required: [
																						"name",
																						"value",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																			libs: {
																				description: "Additional library search dirs"
																				items: type: "string"
																				type: "array"
																			}
																			tlas: {
																				description: "TLAS is a list of Jsonnet Top-level Arguments"

																				items: {
																					description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																					properties: {
																						code: type: "boolean"
																						name: type: "string"
																						value: type: "string"
																					}
																					required: [
																						"name",
																						"value",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																		}
																		type: "object"
																	}
																	recurse: {
																		description: "Recurse specifies whether to scan a directory recursively for manifests"

																		type: "boolean"
																	}
																}
																type: "object"
															}
															helm: {
																description: "Helm holds helm specific options"
																properties: {
																	fileParameters: {
																		description: "FileParameters are file parameters to the helm template"

																		items: {
																			description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																			properties: {
																				name: {
																					description: "Name is the name of the Helm parameter"

																					type: "string"
																				}
																				path: {
																					description: "Path is the path to the file containing the values for the Helm parameter"

																					type: "string"
																				}
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	ignoreMissingValueFiles: {
																		description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																		type: "boolean"
																	}
																	parameters: {
																		description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																		items: {
																			description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																			properties: {
																				forceString: {
																					description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																					type: "boolean"
																				}
																				name: {
																					description: "Name is the name of the Helm parameter"

																					type: "string"
																				}
																				value: {
																					description: "Value is the value for the Helm parameter"

																					type: "string"
																				}
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	passCredentials: {
																		description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																		type: "boolean"
																	}
																	releaseName: {
																		description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																		type: "string"
																	}
																	skipCrds: {
																		description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																		type: "boolean"
																	}
																	valueFiles: {
																		description: "ValuesFiles is a list of Helm value files to use when generating a template"

																		items: type: "string"
																		type: "array"
																	}
																	values: {
																		description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																		type: "string"
																	}
																	valuesObject: {
																		description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																		type:                                   "object"
																		"x-kubernetes-preserve-unknown-fields": true
																	}
																	version: {
																		description: "Version is the Helm version to use for templating (\"3\")"

																		type: "string"
																	}
																}
																type: "object"
															}
															kustomize: {
																description: "Kustomize holds kustomize specific options"
																properties: {
																	commonAnnotations: {
																		additionalProperties: type: "string"
																		description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																		type: "object"
																	}
																	commonAnnotationsEnvsubst: {
																		description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																		type: "boolean"
																	}
																	commonLabels: {
																		additionalProperties: type: "string"
																		description: "CommonLabels is a list of additional labels to add to rendered manifests"

																		type: "object"
																	}
																	components: {
																		description: "Components specifies a list of kustomize components to add to the kustomization before building"

																		items: type: "string"
																		type: "array"
																	}
																	forceCommonAnnotations: {
																		description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																		type: "boolean"
																	}
																	forceCommonLabels: {
																		description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																		type: "boolean"
																	}
																	images: {
																		description: "Images is a list of Kustomize image override specifications"

																		items: {
																			description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																			type: "string"
																		}
																		type: "array"
																	}
																	namePrefix: {
																		description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																		type: "string"
																	}
																	nameSuffix: {
																		description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																		type: "string"
																	}
																	namespace: {
																		description: "Namespace sets the namespace that Kustomize adds to all resources"

																		type: "string"
																	}
																	patches: {
																		description: "Patches is a list of Kustomize patches"
																		items: {
																			properties: {
																				options: {
																					additionalProperties: type: "boolean"
																					type: "object"
																				}
																				patch: type: "string"
																				path: type: "string"
																				target: {
																					properties: {
																						annotationSelector: type: "string"
																						group: type: "string"
																						kind: type: "string"
																						labelSelector: type: "string"
																						name: type: "string"
																						namespace: type: "string"
																						version: type: "string"
																					}
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	replicas: {
																		description: "Replicas is a list of Kustomize Replicas override specifications"

																		items: {
																			properties: {
																				count: {
																					anyOf: [{
																						type: "integer"
																					}, {
																						type: "string"
																					}]
																					description:                  "Number of replicas"
																					"x-kubernetes-int-or-string": true
																				}
																				name: {
																					description: "Name of Deployment or StatefulSet"
																					type:        "string"
																				}
																			}
																			required: [
																				"count",
																				"name",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	version: {
																		description: "Version controls which version of Kustomize to use for rendering manifests"

																		type: "string"
																	}
																}
																type: "object"
															}
															path: {
																description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

																type: "string"
															}
															plugin: {
																description: "Plugin holds config management plugin specific options"

																properties: {
																	env: {
																		description: "Env is a list of environment variable entries"

																		items: {
																			description: "EnvEntry represents an entry in the application's environment"

																			properties: {
																				name: {
																					description: "Name is the name of the variable, usually expressed in uppercase"

																					type: "string"
																				}
																				value: {
																					description: "Value is the value of the variable"
																					type:        "string"
																				}
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	name: type: "string"
																	parameters: {
																		items: {
																			properties: {
																				array: {
																					description: "Array is the value of an array type parameter."

																					items: type: "string"
																					type: "array"
																				}
																				map: {
																					additionalProperties: type: "string"
																					description: "Map is the value of a map type parameter."

																					type: "object"
																				}
																				name: {
																					description: "Name is the name identifying a parameter."

																					type: "string"
																				}
																				string: {
																					description: "String_ is the value of a string type parameter."

																					type: "string"
																				}
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																}
																type: "object"
															}
															ref: {
																description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

																type: "string"
															}
															repoURL: {
																description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

																type: "string"
															}
															targetRevision: {
																description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

																type: "string"
															}
														}
														required: ["repoURL"]
														type: "object"
													}
													sources: {
														description: "Sources overrides the source definition set in the application. This is typically set in a Rollback operation and is nil during a Sync operation"

														items: {
															description: "ApplicationSource contains all required information about the source of an application"

															properties: {
																chart: {
																	description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

																	type: "string"
																}
																directory: {
																	description: "Directory holds path/directory specific options"

																	properties: {
																		exclude: {
																			description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																			type: "string"
																		}
																		include: {
																			description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																			type: "string"
																		}
																		jsonnet: {
																			description: "Jsonnet holds options specific to Jsonnet"

																			properties: {
																				extVars: {
																					description: "ExtVars is a list of Jsonnet External Variables"

																					items: {
																						description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																						properties: {
																							code: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				libs: {
																					description: "Additional library search dirs"
																					items: type: "string"
																					type: "array"
																				}
																				tlas: {
																					description: "TLAS is a list of Jsonnet Top-level Arguments"

																					items: {
																						description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																						properties: {
																							code: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		recurse: {
																			description: "Recurse specifies whether to scan a directory recursively for manifests"

																			type: "boolean"
																		}
																	}
																	type: "object"
																}
																helm: {
																	description: "Helm holds helm specific options"
																	properties: {
																		fileParameters: {
																			description: "FileParameters are file parameters to the helm template"

																			items: {
																				description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																				properties: {
																					name: {
																						description: "Name is the name of the Helm parameter"

																						type: "string"
																					}
																					path: {
																						description: "Path is the path to the file containing the values for the Helm parameter"

																						type: "string"
																					}
																				}
																				type: "object"
																			}
																			type: "array"
																		}
																		ignoreMissingValueFiles: {
																			description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																			type: "boolean"
																		}
																		parameters: {
																			description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																			items: {
																				description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																				properties: {
																					forceString: {
																						description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																						type: "boolean"
																					}
																					name: {
																						description: "Name is the name of the Helm parameter"

																						type: "string"
																					}
																					value: {
																						description: "Value is the value for the Helm parameter"

																						type: "string"
																					}
																				}
																				type: "object"
																			}
																			type: "array"
																		}
																		passCredentials: {
																			description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																			type: "boolean"
																		}
																		releaseName: {
																			description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																			type: "string"
																		}
																		skipCrds: {
																			description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																			type: "boolean"
																		}
																		valueFiles: {
																			description: "ValuesFiles is a list of Helm value files to use when generating a template"

																			items: type: "string"
																			type: "array"
																		}
																		values: {
																			description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																			type: "string"
																		}
																		valuesObject: {
																			description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																			type:                                   "object"
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		version: {
																			description: "Version is the Helm version to use for templating (\"3\")"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																kustomize: {
																	description: "Kustomize holds kustomize specific options"

																	properties: {
																		commonAnnotations: {
																			additionalProperties: type: "string"
																			description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																			type: "object"
																		}
																		commonAnnotationsEnvsubst: {
																			description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																			type: "boolean"
																		}
																		commonLabels: {
																			additionalProperties: type: "string"
																			description: "CommonLabels is a list of additional labels to add to rendered manifests"

																			type: "object"
																		}
																		components: {
																			description: "Components specifies a list of kustomize components to add to the kustomization before building"

																			items: type: "string"
																			type: "array"
																		}
																		forceCommonAnnotations: {
																			description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																			type: "boolean"
																		}
																		forceCommonLabels: {
																			description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																			type: "boolean"
																		}
																		images: {
																			description: "Images is a list of Kustomize image override specifications"

																			items: {
																				description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																				type: "string"
																			}
																			type: "array"
																		}
																		namePrefix: {
																			description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																			type: "string"
																		}
																		nameSuffix: {
																			description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																			type: "string"
																		}
																		namespace: {
																			description: "Namespace sets the namespace that Kustomize adds to all resources"

																			type: "string"
																		}
																		patches: {
																			description: "Patches is a list of Kustomize patches"

																			items: {
																				properties: {
																					options: {
																						additionalProperties: type: "boolean"
																						type: "object"
																					}
																					patch: type: "string"
																					path: type: "string"
																					target: {
																						properties: {
																							annotationSelector: type: "string"
																							group: type: "string"
																							kind: type: "string"
																							labelSelector: type: "string"
																							name: type: "string"
																							namespace: type: "string"
																							version: type: "string"
																						}
																						type: "object"
																					}
																				}
																				type: "object"
																			}
																			type: "array"
																		}
																		replicas: {
																			description: "Replicas is a list of Kustomize Replicas override specifications"

																			items: {
																				properties: {
																					count: {
																						anyOf: [{
																							type: "integer"
																						}, {
																							type: "string"
																						}]
																						description:                  "Number of replicas"
																						"x-kubernetes-int-or-string": true
																					}
																					name: {
																						description: "Name of Deployment or StatefulSet"
																						type:        "string"
																					}
																				}
																				required: [
																					"count",
																					"name",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																		version: {
																			description: "Version controls which version of Kustomize to use for rendering manifests"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																path: {
																	description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

																	type: "string"
																}
																plugin: {
																	description: "Plugin holds config management plugin specific options"

																	properties: {
																		env: {
																			description: "Env is a list of environment variable entries"

																			items: {
																				description: "EnvEntry represents an entry in the application's environment"

																				properties: {
																					name: {
																						description: "Name is the name of the variable, usually expressed in uppercase"

																						type: "string"
																					}
																					value: {
																						description: "Value is the value of the variable"

																						type: "string"
																					}
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																		name: type: "string"
																		parameters: {
																			items: {
																				properties: {
																					array: {
																						description: "Array is the value of an array type parameter."

																						items: type: "string"
																						type: "array"
																					}
																					map: {
																						additionalProperties: type: "string"
																						description: "Map is the value of a map type parameter."

																						type: "object"
																					}
																					name: {
																						description: "Name is the name identifying a parameter."

																						type: "string"
																					}
																					string: {
																						description: "String_ is the value of a string type parameter."

																						type: "string"
																					}
																				}
																				type: "object"
																			}
																			type: "array"
																		}
																	}
																	type: "object"
																}
																ref: {
																	description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

																	type: "string"
																}
																repoURL: {
																	description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

																	type: "string"
																}
																targetRevision: {
																	description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

																	type: "string"
																}
															}
															required: ["repoURL"]
															type: "object"
														}
														type: "array"
													}
													syncOptions: {
														description: "SyncOptions provide per-sync sync-options, e.g. Validate=false"

														items: type: "string"
														type: "array"
													}
													syncStrategy: {
														description: "SyncStrategy describes how to perform the sync"

														properties: {
															apply: {
																description: "Apply will perform a `kubectl apply` to perform the sync."

																properties: force: {
																	description: "Force indicates whether or not to supply the --force flag to `kubectl apply`. The --force flag deletes and re-create the resource, when PATCH encounters conflict and has retried for 5 times."

																	type: "boolean"
																}
																type: "object"
															}
															hook: {
																description: "Hook will submit any referenced resources to perform the sync. This is the default strategy"

																properties: force: {
																	description: "Force indicates whether or not to supply the --force flag to `kubectl apply`. The --force flag deletes and re-create the resource, when PATCH encounters conflict and has retried for 5 times."

																	type: "boolean"
																}
																type: "object"
															}
														}
														type: "object"
													}
												}
												type: "object"
											}
										}
										type: "object"
									}
									phase: {
										description: "Phase is the current phase of the operation"
										type:        "string"
									}
									retryCount: {
										description: "RetryCount contains time of operation retries"
										format:      "int64"
										type:        "integer"
									}
									startedAt: {
										description: "StartedAt contains time of operation start"
										format:      "date-time"
										type:        "string"
									}
									syncResult: {
										description: "SyncResult is the result of a Sync operation"
										properties: {
											managedNamespaceMetadata: {
												description: "ManagedNamespaceMetadata contains the current sync state of managed namespace metadata"

												properties: {
													annotations: {
														additionalProperties: type: "string"
														type: "object"
													}
													labels: {
														additionalProperties: type: "string"
														type: "object"
													}
												}
												type: "object"
											}
											resources: {
												description: "Resources contains a list of sync result items for each individual resource in a sync operation"

												items: {
													description: "ResourceResult holds the operation result details of a specific resource"

													properties: {
														group: {
															description: "Group specifies the API group of the resource"
															type:        "string"
														}
														hookPhase: {
															description: "HookPhase contains the state of any operation associated with this resource OR hook This can also contain values for non-hook resources."

															type: "string"
														}
														hookType: {
															description: "HookType specifies the type of the hook. Empty for non-hook resources"

															type: "string"
														}
														kind: {
															description: "Kind specifies the API kind of the resource"
															type:        "string"
														}
														message: {
															description: "Message contains an informational or error message for the last sync OR operation"

															type: "string"
														}
														name: {
															description: "Name specifies the name of the resource"
															type:        "string"
														}
														namespace: {
															description: "Namespace specifies the target namespace of the resource"

															type: "string"
														}
														status: {
															description: "Status holds the final result of the sync. Will be empty if the resources is yet to be applied/pruned and is always zero-value for hooks"

															type: "string"
														}
														syncPhase: {
															description: "SyncPhase indicates the particular phase of the sync that this result was acquired in"

															type: "string"
														}
														version: {
															description: "Version specifies the API version of the resource"

															type: "string"
														}
													}
													required: [
														"group",
														"kind",
														"name",
														"namespace",
														"version",
													]
													type: "object"
												}
												type: "array"
											}
											revision: {
												description: "Revision holds the revision this sync operation was performed to"

												type: "string"
											}
											revisions: {
												description: "Revisions holds the revision this sync operation was performed for respective indexed source in sources field"

												items: type: "string"
												type: "array"
											}
											source: {
												description: "Source records the application source information of the sync, used for comparing auto-sync"

												properties: {
													chart: {
														description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

														type: "string"
													}
													directory: {
														description: "Directory holds path/directory specific options"
														properties: {
															exclude: {
																description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																type: "string"
															}
															include: {
																description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																type: "string"
															}
															jsonnet: {
																description: "Jsonnet holds options specific to Jsonnet"
																properties: {
																	extVars: {
																		description: "ExtVars is a list of Jsonnet External Variables"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	libs: {
																		description: "Additional library search dirs"
																		items: type: "string"
																		type: "array"
																	}
																	tlas: {
																		description: "TLAS is a list of Jsonnet Top-level Arguments"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																}
																type: "object"
															}
															recurse: {
																description: "Recurse specifies whether to scan a directory recursively for manifests"

																type: "boolean"
															}
														}
														type: "object"
													}
													helm: {
														description: "Helm holds helm specific options"
														properties: {
															fileParameters: {
																description: "FileParameters are file parameters to the helm template"

																items: {
																	description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																	properties: {
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		path: {
																			description: "Path is the path to the file containing the values for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															ignoreMissingValueFiles: {
																description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																type: "boolean"
															}
															parameters: {
																description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																items: {
																	description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																	properties: {
																		forceString: {
																			description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																			type: "boolean"
																		}
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		value: {
																			description: "Value is the value for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															passCredentials: {
																description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																type: "boolean"
															}
															releaseName: {
																description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																type: "string"
															}
															skipCrds: {
																description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																type: "boolean"
															}
															valueFiles: {
																description: "ValuesFiles is a list of Helm value files to use when generating a template"

																items: type: "string"
																type: "array"
															}
															values: {
																description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																type: "string"
															}
															valuesObject: {
																description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																type:                                   "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															version: {
																description: "Version is the Helm version to use for templating (\"3\")"

																type: "string"
															}
														}
														type: "object"
													}
													kustomize: {
														description: "Kustomize holds kustomize specific options"
														properties: {
															commonAnnotations: {
																additionalProperties: type: "string"
																description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																type: "object"
															}
															commonAnnotationsEnvsubst: {
																description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																type: "boolean"
															}
															commonLabels: {
																additionalProperties: type: "string"
																description: "CommonLabels is a list of additional labels to add to rendered manifests"

																type: "object"
															}
															components: {
																description: "Components specifies a list of kustomize components to add to the kustomization before building"

																items: type: "string"
																type: "array"
															}
															forceCommonAnnotations: {
																description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																type: "boolean"
															}
															forceCommonLabels: {
																description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																type: "boolean"
															}
															images: {
																description: "Images is a list of Kustomize image override specifications"

																items: {
																	description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																	type: "string"
																}
																type: "array"
															}
															namePrefix: {
																description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																type: "string"
															}
															nameSuffix: {
																description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																type: "string"
															}
															namespace: {
																description: "Namespace sets the namespace that Kustomize adds to all resources"

																type: "string"
															}
															patches: {
																description: "Patches is a list of Kustomize patches"
																items: {
																	properties: {
																		options: {
																			additionalProperties: type: "boolean"
																			type: "object"
																		}
																		patch: type: "string"
																		path: type: "string"
																		target: {
																			properties: {
																				annotationSelector: type: "string"
																				group: type: "string"
																				kind: type: "string"
																				labelSelector: type: "string"
																				name: type: "string"
																				namespace: type: "string"
																				version: type: "string"
																			}
																			type: "object"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															replicas: {
																description: "Replicas is a list of Kustomize Replicas override specifications"

																items: {
																	properties: {
																		count: {
																			anyOf: [{
																				type: "integer"
																			}, {
																				type: "string"
																			}]
																			description:                  "Number of replicas"
																			"x-kubernetes-int-or-string": true
																		}
																		name: {
																			description: "Name of Deployment or StatefulSet"
																			type:        "string"
																		}
																	}
																	required: [
																		"count",
																		"name",
																	]
																	type: "object"
																}
																type: "array"
															}
															version: {
																description: "Version controls which version of Kustomize to use for rendering manifests"

																type: "string"
															}
														}
														type: "object"
													}
													path: {
														description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

														type: "string"
													}
													plugin: {
														description: "Plugin holds config management plugin specific options"

														properties: {
															env: {
																description: "Env is a list of environment variable entries"

																items: {
																	description: "EnvEntry represents an entry in the application's environment"

																	properties: {
																		name: {
																			description: "Name is the name of the variable, usually expressed in uppercase"

																			type: "string"
																		}
																		value: {
																			description: "Value is the value of the variable"
																			type:        "string"
																		}
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
															name: type: "string"
															parameters: {
																items: {
																	properties: {
																		array: {
																			description: "Array is the value of an array type parameter."

																			items: type: "string"
																			type: "array"
																		}
																		map: {
																			additionalProperties: type: "string"
																			description: "Map is the value of a map type parameter."

																			type: "object"
																		}
																		name: {
																			description: "Name is the name identifying a parameter."

																			type: "string"
																		}
																		string: {
																			description: "String_ is the value of a string type parameter."

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
														}
														type: "object"
													}
													ref: {
														description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

														type: "string"
													}
													repoURL: {
														description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

														type: "string"
													}
													targetRevision: {
														description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

														type: "string"
													}
												}
												required: ["repoURL"]
												type: "object"
											}
											sources: {
												description: "Source records the application source information of the sync, used for comparing auto-sync"

												items: {
													description: "ApplicationSource contains all required information about the source of an application"

													properties: {
														chart: {
															description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

															type: "string"
														}
														directory: {
															description: "Directory holds path/directory specific options"

															properties: {
																exclude: {
																	description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																	type: "string"
																}
																include: {
																	description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																	type: "string"
																}
																jsonnet: {
																	description: "Jsonnet holds options specific to Jsonnet"
																	properties: {
																		extVars: {
																			description: "ExtVars is a list of Jsonnet External Variables"

																			items: {
																				description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																		libs: {
																			description: "Additional library search dirs"
																			items: type: "string"
																			type: "array"
																		}
																		tlas: {
																			description: "TLAS is a list of Jsonnet Top-level Arguments"

																			items: {
																				description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																	}
																	type: "object"
																}
																recurse: {
																	description: "Recurse specifies whether to scan a directory recursively for manifests"

																	type: "boolean"
																}
															}
															type: "object"
														}
														helm: {
															description: "Helm holds helm specific options"
															properties: {
																fileParameters: {
																	description: "FileParameters are file parameters to the helm template"

																	items: {
																		description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																		properties: {
																			name: {
																				description: "Name is the name of the Helm parameter"

																				type: "string"
																			}
																			path: {
																				description: "Path is the path to the file containing the values for the Helm parameter"

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																ignoreMissingValueFiles: {
																	description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																	type: "boolean"
																}
																parameters: {
																	description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																	items: {
																		description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																		properties: {
																			forceString: {
																				description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																				type: "boolean"
																			}
																			name: {
																				description: "Name is the name of the Helm parameter"

																				type: "string"
																			}
																			value: {
																				description: "Value is the value for the Helm parameter"

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																passCredentials: {
																	description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																	type: "boolean"
																}
																releaseName: {
																	description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																	type: "string"
																}
																skipCrds: {
																	description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																	type: "boolean"
																}
																valueFiles: {
																	description: "ValuesFiles is a list of Helm value files to use when generating a template"

																	items: type: "string"
																	type: "array"
																}
																values: {
																	description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																	type: "string"
																}
																valuesObject: {
																	description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																	type:                                   "object"
																	"x-kubernetes-preserve-unknown-fields": true
																}
																version: {
																	description: "Version is the Helm version to use for templating (\"3\")"

																	type: "string"
																}
															}
															type: "object"
														}
														kustomize: {
															description: "Kustomize holds kustomize specific options"
															properties: {
																commonAnnotations: {
																	additionalProperties: type: "string"
																	description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																	type: "object"
																}
																commonAnnotationsEnvsubst: {
																	description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																	type: "boolean"
																}
																commonLabels: {
																	additionalProperties: type: "string"
																	description: "CommonLabels is a list of additional labels to add to rendered manifests"

																	type: "object"
																}
																components: {
																	description: "Components specifies a list of kustomize components to add to the kustomization before building"

																	items: type: "string"
																	type: "array"
																}
																forceCommonAnnotations: {
																	description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																	type: "boolean"
																}
																forceCommonLabels: {
																	description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																	type: "boolean"
																}
																images: {
																	description: "Images is a list of Kustomize image override specifications"

																	items: {
																		description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																		type: "string"
																	}
																	type: "array"
																}
																namePrefix: {
																	description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																	type: "string"
																}
																nameSuffix: {
																	description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																	type: "string"
																}
																namespace: {
																	description: "Namespace sets the namespace that Kustomize adds to all resources"

																	type: "string"
																}
																patches: {
																	description: "Patches is a list of Kustomize patches"
																	items: {
																		properties: {
																			options: {
																				additionalProperties: type: "boolean"
																				type: "object"
																			}
																			patch: type: "string"
																			path: type: "string"
																			target: {
																				properties: {
																					annotationSelector: type: "string"
																					group: type: "string"
																					kind: type: "string"
																					labelSelector: type: "string"
																					name: type: "string"
																					namespace: type: "string"
																					version: type: "string"
																				}
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																replicas: {
																	description: "Replicas is a list of Kustomize Replicas override specifications"

																	items: {
																		properties: {
																			count: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				description:                  "Number of replicas"
																				"x-kubernetes-int-or-string": true
																			}
																			name: {
																				description: "Name of Deployment or StatefulSet"
																				type:        "string"
																			}
																		}
																		required: [
																			"count",
																			"name",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																version: {
																	description: "Version controls which version of Kustomize to use for rendering manifests"

																	type: "string"
																}
															}
															type: "object"
														}
														path: {
															description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

															type: "string"
														}
														plugin: {
															description: "Plugin holds config management plugin specific options"

															properties: {
																env: {
																	description: "Env is a list of environment variable entries"

																	items: {
																		description: "EnvEntry represents an entry in the application's environment"

																		properties: {
																			name: {
																				description: "Name is the name of the variable, usually expressed in uppercase"

																				type: "string"
																			}
																			value: {
																				description: "Value is the value of the variable"
																				type:        "string"
																			}
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																name: type: "string"
																parameters: {
																	items: {
																		properties: {
																			array: {
																				description: "Array is the value of an array type parameter."

																				items: type: "string"
																				type: "array"
																			}
																			map: {
																				additionalProperties: type: "string"
																				description: "Map is the value of a map type parameter."

																				type: "object"
																			}
																			name: {
																				description: "Name is the name identifying a parameter."

																				type: "string"
																			}
																			string: {
																				description: "String_ is the value of a string type parameter."

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
															}
															type: "object"
														}
														ref: {
															description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

															type: "string"
														}
														repoURL: {
															description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

															type: "string"
														}
														targetRevision: {
															description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

															type: "string"
														}
													}
													required: ["repoURL"]
													type: "object"
												}
												type: "array"
											}
										}
										required: ["revision"]
										type: "object"
									}
								}
								required: [
									"operation",
									"phase",
									"startedAt",
								]
								type: "object"
							}
							reconciledAt: {
								description: "ReconciledAt indicates when the application state was reconciled using the latest git version"

								format: "date-time"
								type:   "string"
							}
							resourceHealthSource: {
								description: "ResourceHealthSource indicates where the resource health status is stored: inline if not set or appTree"

								type: "string"
							}
							resources: {
								description: "Resources is a list of Kubernetes resources managed by this application"

								items: {
									description: "ResourceStatus holds the current sync and health status of a resource TODO: describe members of this type"

									properties: {
										group: type: "string"
										health: {
											description: "HealthStatus contains information about the currently observed health state of an application or resource"

											properties: {
												message: {
													description: "Message is a human-readable informational message describing the health status"

													type: "string"
												}
												status: {
													description: "Status holds the status code of the application or resource"

													type: "string"
												}
											}
											type: "object"
										}
										hook: type: "boolean"
										kind: type: "string"
										name: type: "string"
										namespace: type: "string"
										requiresPruning: type: "boolean"
										status: {
											description: "SyncStatusCode is a type which represents possible comparison results"

											type: "string"
										}
										syncWave: {
											format: "int64"
											type:   "integer"
										}
										version: type: "string"
									}
									type: "object"
								}
								type: "array"
							}
							sourceType: {
								description: "SourceType specifies the type of this application"
								type:        "string"
							}
							sourceTypes: {
								description: "SourceTypes specifies the type of the sources included in the application"

								items: {
									description: "ApplicationSourceType specifies the type of the application's source"

									type: "string"
								}
								type: "array"
							}
							summary: {
								description: "Summary contains a list of URLs and container images used by this application"

								properties: {
									externalURLs: {
										description: "ExternalURLs holds all external URLs of application child resources."

										items: type: "string"
										type: "array"
									}
									images: {
										description: "Images holds all images of application child resources."
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							sync: {
								description: "Sync contains information about the application's current sync status"

								properties: {
									comparedTo: {
										description: "ComparedTo contains information about what has been compared"

										properties: {
											destination: {
												description: "Destination is a reference to the application's destination used for comparison"

												properties: {
													name: {
														description: "Name is an alternate way of specifying the target cluster by its symbolic name. This must be set if Server is not set."

														type: "string"
													}
													namespace: {
														description: "Namespace specifies the target namespace for the application's resources. The namespace will only be set for namespace-scoped resources that have not set a value for .metadata.namespace"

														type: "string"
													}
													server: {
														description: "Server specifies the URL of the target cluster's Kubernetes control plane API. This must be set if Name is not set."

														type: "string"
													}
												}
												type: "object"
											}
											ignoreDifferences: {
												description: "IgnoreDifferences is a reference to the application's ignored differences used for comparison"

												items: {
													description: "ResourceIgnoreDifferences contains resource filter and list of json paths which should be ignored during comparison with live state."

													properties: {
														group: type: "string"
														jqPathExpressions: {
															items: type: "string"
															type: "array"
														}
														jsonPointers: {
															items: type: "string"
															type: "array"
														}
														kind: type: "string"
														managedFieldsManagers: {
															description: "ManagedFieldsManagers is a list of trusted managers. Fields mutated by those managers will take precedence over the desired state defined in the SCM and won't be displayed in diffs"

															items: type: "string"
															type: "array"
														}
														name: type: "string"
														namespace: type: "string"
													}
													required: ["kind"]
													type: "object"
												}
												type: "array"
											}
											source: {
												description: "Source is a reference to the application's source used for comparison"

												properties: {
													chart: {
														description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

														type: "string"
													}
													directory: {
														description: "Directory holds path/directory specific options"
														properties: {
															exclude: {
																description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																type: "string"
															}
															include: {
																description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																type: "string"
															}
															jsonnet: {
																description: "Jsonnet holds options specific to Jsonnet"
																properties: {
																	extVars: {
																		description: "ExtVars is a list of Jsonnet External Variables"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	libs: {
																		description: "Additional library search dirs"
																		items: type: "string"
																		type: "array"
																	}
																	tlas: {
																		description: "TLAS is a list of Jsonnet Top-level Arguments"

																		items: {
																			description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																}
																type: "object"
															}
															recurse: {
																description: "Recurse specifies whether to scan a directory recursively for manifests"

																type: "boolean"
															}
														}
														type: "object"
													}
													helm: {
														description: "Helm holds helm specific options"
														properties: {
															fileParameters: {
																description: "FileParameters are file parameters to the helm template"

																items: {
																	description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																	properties: {
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		path: {
																			description: "Path is the path to the file containing the values for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															ignoreMissingValueFiles: {
																description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																type: "boolean"
															}
															parameters: {
																description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																items: {
																	description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																	properties: {
																		forceString: {
																			description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																			type: "boolean"
																		}
																		name: {
																			description: "Name is the name of the Helm parameter"
																			type:        "string"
																		}
																		value: {
																			description: "Value is the value for the Helm parameter"

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															passCredentials: {
																description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																type: "boolean"
															}
															releaseName: {
																description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																type: "string"
															}
															skipCrds: {
																description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																type: "boolean"
															}
															valueFiles: {
																description: "ValuesFiles is a list of Helm value files to use when generating a template"

																items: type: "string"
																type: "array"
															}
															values: {
																description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																type: "string"
															}
															valuesObject: {
																description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																type:                                   "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															version: {
																description: "Version is the Helm version to use for templating (\"3\")"

																type: "string"
															}
														}
														type: "object"
													}
													kustomize: {
														description: "Kustomize holds kustomize specific options"
														properties: {
															commonAnnotations: {
																additionalProperties: type: "string"
																description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																type: "object"
															}
															commonAnnotationsEnvsubst: {
																description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																type: "boolean"
															}
															commonLabels: {
																additionalProperties: type: "string"
																description: "CommonLabels is a list of additional labels to add to rendered manifests"

																type: "object"
															}
															components: {
																description: "Components specifies a list of kustomize components to add to the kustomization before building"

																items: type: "string"
																type: "array"
															}
															forceCommonAnnotations: {
																description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																type: "boolean"
															}
															forceCommonLabels: {
																description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																type: "boolean"
															}
															images: {
																description: "Images is a list of Kustomize image override specifications"

																items: {
																	description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																	type: "string"
																}
																type: "array"
															}
															namePrefix: {
																description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																type: "string"
															}
															nameSuffix: {
																description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																type: "string"
															}
															namespace: {
																description: "Namespace sets the namespace that Kustomize adds to all resources"

																type: "string"
															}
															patches: {
																description: "Patches is a list of Kustomize patches"
																items: {
																	properties: {
																		options: {
																			additionalProperties: type: "boolean"
																			type: "object"
																		}
																		patch: type: "string"
																		path: type: "string"
																		target: {
																			properties: {
																				annotationSelector: type: "string"
																				group: type: "string"
																				kind: type: "string"
																				labelSelector: type: "string"
																				name: type: "string"
																				namespace: type: "string"
																				version: type: "string"
																			}
																			type: "object"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															replicas: {
																description: "Replicas is a list of Kustomize Replicas override specifications"

																items: {
																	properties: {
																		count: {
																			anyOf: [{
																				type: "integer"
																			}, {
																				type: "string"
																			}]
																			description:                  "Number of replicas"
																			"x-kubernetes-int-or-string": true
																		}
																		name: {
																			description: "Name of Deployment or StatefulSet"
																			type:        "string"
																		}
																	}
																	required: [
																		"count",
																		"name",
																	]
																	type: "object"
																}
																type: "array"
															}
															version: {
																description: "Version controls which version of Kustomize to use for rendering manifests"

																type: "string"
															}
														}
														type: "object"
													}
													path: {
														description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

														type: "string"
													}
													plugin: {
														description: "Plugin holds config management plugin specific options"

														properties: {
															env: {
																description: "Env is a list of environment variable entries"

																items: {
																	description: "EnvEntry represents an entry in the application's environment"

																	properties: {
																		name: {
																			description: "Name is the name of the variable, usually expressed in uppercase"

																			type: "string"
																		}
																		value: {
																			description: "Value is the value of the variable"
																			type:        "string"
																		}
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
															name: type: "string"
															parameters: {
																items: {
																	properties: {
																		array: {
																			description: "Array is the value of an array type parameter."

																			items: type: "string"
																			type: "array"
																		}
																		map: {
																			additionalProperties: type: "string"
																			description: "Map is the value of a map type parameter."

																			type: "object"
																		}
																		name: {
																			description: "Name is the name identifying a parameter."

																			type: "string"
																		}
																		string: {
																			description: "String_ is the value of a string type parameter."

																			type: "string"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
														}
														type: "object"
													}
													ref: {
														description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

														type: "string"
													}
													repoURL: {
														description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

														type: "string"
													}
													targetRevision: {
														description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

														type: "string"
													}
												}
												required: ["repoURL"]
												type: "object"
											}
											sources: {
												description: "Sources is a reference to the application's multiple sources used for comparison"

												items: {
													description: "ApplicationSource contains all required information about the source of an application"

													properties: {
														chart: {
															description: "Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo."

															type: "string"
														}
														directory: {
															description: "Directory holds path/directory specific options"

															properties: {
																exclude: {
																	description: "Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation"

																	type: "string"
																}
																include: {
																	description: "Include contains a glob pattern to match paths against that should be explicitly included during manifest generation"

																	type: "string"
																}
																jsonnet: {
																	description: "Jsonnet holds options specific to Jsonnet"
																	properties: {
																		extVars: {
																			description: "ExtVars is a list of Jsonnet External Variables"

																			items: {
																				description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																		libs: {
																			description: "Additional library search dirs"
																			items: type: "string"
																			type: "array"
																		}
																		tlas: {
																			description: "TLAS is a list of Jsonnet Top-level Arguments"

																			items: {
																				description: "JsonnetVar represents a variable to be passed to jsonnet during manifest generation"

																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																	}
																	type: "object"
																}
																recurse: {
																	description: "Recurse specifies whether to scan a directory recursively for manifests"

																	type: "boolean"
																}
															}
															type: "object"
														}
														helm: {
															description: "Helm holds helm specific options"
															properties: {
																fileParameters: {
																	description: "FileParameters are file parameters to the helm template"

																	items: {
																		description: "HelmFileParameter is a file parameter that's passed to helm template during manifest generation"

																		properties: {
																			name: {
																				description: "Name is the name of the Helm parameter"

																				type: "string"
																			}
																			path: {
																				description: "Path is the path to the file containing the values for the Helm parameter"

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																ignoreMissingValueFiles: {
																	description: "IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values"

																	type: "boolean"
																}
																parameters: {
																	description: "Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation"

																	items: {
																		description: "HelmParameter is a parameter that's passed to helm template during manifest generation"

																		properties: {
																			forceString: {
																				description: "ForceString determines whether to tell Helm to interpret booleans and numbers as strings"

																				type: "boolean"
																			}
																			name: {
																				description: "Name is the name of the Helm parameter"

																				type: "string"
																			}
																			value: {
																				description: "Value is the value for the Helm parameter"

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																passCredentials: {
																	description: "PassCredentials pass credentials to all domains (Helm's --pass-credentials)"

																	type: "boolean"
																}
																releaseName: {
																	description: "ReleaseName is the Helm release name to use. If omitted it will use the application name"

																	type: "string"
																}
																skipCrds: {
																	description: "SkipCrds skips custom resource definition installation step (Helm's --skip-crds)"

																	type: "boolean"
																}
																valueFiles: {
																	description: "ValuesFiles is a list of Helm value files to use when generating a template"

																	items: type: "string"
																	type: "array"
																}
																values: {
																	description: "Values specifies Helm values to be passed to helm template, typically defined as a block. ValuesObject takes precedence over Values, so use one or the other."

																	type: "string"
																}
																valuesObject: {
																	description: "ValuesObject specifies Helm values to be passed to helm template, defined as a map. This takes precedence over Values."

																	type:                                   "object"
																	"x-kubernetes-preserve-unknown-fields": true
																}
																version: {
																	description: "Version is the Helm version to use for templating (\"3\")"

																	type: "string"
																}
															}
															type: "object"
														}
														kustomize: {
															description: "Kustomize holds kustomize specific options"
															properties: {
																commonAnnotations: {
																	additionalProperties: type: "string"
																	description: "CommonAnnotations is a list of additional annotations to add to rendered manifests"

																	type: "object"
																}
																commonAnnotationsEnvsubst: {
																	description: "CommonAnnotationsEnvsubst specifies whether to apply env variables substitution for annotation values"

																	type: "boolean"
																}
																commonLabels: {
																	additionalProperties: type: "string"
																	description: "CommonLabels is a list of additional labels to add to rendered manifests"

																	type: "object"
																}
																components: {
																	description: "Components specifies a list of kustomize components to add to the kustomization before building"

																	items: type: "string"
																	type: "array"
																}
																forceCommonAnnotations: {
																	description: "ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps"

																	type: "boolean"
																}
																forceCommonLabels: {
																	description: "ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps"

																	type: "boolean"
																}
																images: {
																	description: "Images is a list of Kustomize image override specifications"

																	items: {
																		description: "KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>"

																		type: "string"
																	}
																	type: "array"
																}
																namePrefix: {
																	description: "NamePrefix is a prefix appended to resources for Kustomize apps"

																	type: "string"
																}
																nameSuffix: {
																	description: "NameSuffix is a suffix appended to resources for Kustomize apps"

																	type: "string"
																}
																namespace: {
																	description: "Namespace sets the namespace that Kustomize adds to all resources"

																	type: "string"
																}
																patches: {
																	description: "Patches is a list of Kustomize patches"
																	items: {
																		properties: {
																			options: {
																				additionalProperties: type: "boolean"
																				type: "object"
																			}
																			patch: type: "string"
																			path: type: "string"
																			target: {
																				properties: {
																					annotationSelector: type: "string"
																					group: type: "string"
																					kind: type: "string"
																					labelSelector: type: "string"
																					name: type: "string"
																					namespace: type: "string"
																					version: type: "string"
																				}
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																replicas: {
																	description: "Replicas is a list of Kustomize Replicas override specifications"

																	items: {
																		properties: {
																			count: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				description:                  "Number of replicas"
																				"x-kubernetes-int-or-string": true
																			}
																			name: {
																				description: "Name of Deployment or StatefulSet"
																				type:        "string"
																			}
																		}
																		required: [
																			"count",
																			"name",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																version: {
																	description: "Version controls which version of Kustomize to use for rendering manifests"

																	type: "string"
																}
															}
															type: "object"
														}
														path: {
															description: "Path is a directory path within the Git repository, and is only valid for applications sourced from Git."

															type: "string"
														}
														plugin: {
															description: "Plugin holds config management plugin specific options"

															properties: {
																env: {
																	description: "Env is a list of environment variable entries"

																	items: {
																		description: "EnvEntry represents an entry in the application's environment"

																		properties: {
																			name: {
																				description: "Name is the name of the variable, usually expressed in uppercase"

																				type: "string"
																			}
																			value: {
																				description: "Value is the value of the variable"
																				type:        "string"
																			}
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																name: type: "string"
																parameters: {
																	items: {
																		properties: {
																			array: {
																				description: "Array is the value of an array type parameter."

																				items: type: "string"
																				type: "array"
																			}
																			map: {
																				additionalProperties: type: "string"
																				description: "Map is the value of a map type parameter."

																				type: "object"
																			}
																			name: {
																				description: "Name is the name identifying a parameter."

																				type: "string"
																			}
																			string: {
																				description: "String_ is the value of a string type parameter."

																				type: "string"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
															}
															type: "object"
														}
														ref: {
															description: "Ref is reference to another source within sources field. This field will not be used if used with a `source` tag."

															type: "string"
														}
														repoURL: {
															description: "RepoURL is the URL to the repository (Git or Helm) that contains the application manifests"

															type: "string"
														}
														targetRevision: {
															description: "TargetRevision defines the revision of the source to sync the application to. In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD. In case of Helm, this is a semver tag for the Chart's version."

															type: "string"
														}
													}
													required: ["repoURL"]
													type: "object"
												}
												type: "array"
											}
										}
										required: ["destination"]
										type: "object"
									}
									revision: {
										description: "Revision contains information about the revision the comparison has been performed to"

										type: "string"
									}
									revisions: {
										description: "Revisions contains information about the revisions of multiple sources the comparison has been performed to"

										items: type: "string"
										type: "array"
									}
									status: {
										description: "Status is the sync state of the comparison"
										type:        "string"
									}
								}
								required: ["status"]
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
			subresources: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "applicationsets.argoproj.io": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "applicationsets.argoproj.io"
			"app.kubernetes.io/part-of": "argocd"
		}
		name: "applicationsets.argoproj.io"
	}
	spec: {
		group: "argoproj.io"
		names: {
			kind:     "ApplicationSet"
			listKind: "ApplicationSetList"
			plural:   "applicationsets"
			shortNames: [
				"appset",
				"appsets",
			]
			singular: "applicationset"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				properties: {
					apiVersion: type: "string"
					kind: type: "string"
					metadata: type: "object"
					spec: {
						properties: {
							applyNestedSelectors: type: "boolean"
							generators: {
								items: {
									properties: {
										clusterDecisionResource: {
											properties: {
												configMapRef: type: "string"
												labelSelector: {
													properties: {
														matchExpressions: {
															items: {
																properties: {
																	key: type: "string"
																	operator: type: "string"
																	values: {
																		items: type: "string"
																		type: "array"
																	}
																}
																required: [
																	"key",
																	"operator",
																]
																type: "object"
															}
															type: "array"
														}
														matchLabels: {
															additionalProperties: type: "string"
															type: "object"
														}
													}
													type: "object"
												}
												name: type: "string"
												requeueAfterSeconds: {
													format: "int64"
													type:   "integer"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
												values: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											required: ["configMapRef"]
											type: "object"
										}
										clusters: {
											properties: {
												selector: {
													properties: {
														matchExpressions: {
															items: {
																properties: {
																	key: type: "string"
																	operator: type: "string"
																	values: {
																		items: type: "string"
																		type: "array"
																	}
																}
																required: [
																	"key",
																	"operator",
																]
																type: "object"
															}
															type: "array"
														}
														matchLabels: {
															additionalProperties: type: "string"
															type: "object"
														}
													}
													type: "object"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
												values: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											type: "object"
										}
										git: {
											properties: {
												directories: {
													items: {
														properties: {
															exclude: type: "boolean"
															path: type: "string"
														}
														required: ["path"]
														type: "object"
													}
													type: "array"
												}
												files: {
													items: {
														properties: path: type: "string"
														required: ["path"]
														type: "object"
													}
													type: "array"
												}
												pathParamPrefix: type: "string"
												repoURL: type: "string"
												requeueAfterSeconds: {
													format: "int64"
													type:   "integer"
												}
												revision: type: "string"
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
												values: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											required: [
												"repoURL",
												"revision",
											]
											type: "object"
										}
										list: {
											properties: {
												elements: {
													items: "x-kubernetes-preserve-unknown-fields": true
													type: "array"
												}
												elementsYaml: type: "string"
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
											}
											required: ["elements"]
											type: "object"
										}
										matrix: {
											properties: {
												generators: {
													items: {
														properties: {
															clusterDecisionResource: {
																properties: {
																	configMapRef: type: "string"
																	labelSelector: {
																		properties: {
																			matchExpressions: {
																				items: {
																					properties: {
																						key: type: "string"
																						operator: type: "string"
																						values: {
																							items: type: "string"
																							type: "array"
																						}
																					}
																					required: [
																						"key",
																						"operator",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																			matchLabels: {
																				additionalProperties: type: "string"
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	name: type: "string"
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: ["configMapRef"]
																type: "object"
															}
															clusters: {
																properties: {
																	selector: {
																		properties: {
																			matchExpressions: {
																				items: {
																					properties: {
																						key: type: "string"
																						operator: type: "string"
																						values: {
																							items: type: "string"
																							type: "array"
																						}
																					}
																					required: [
																						"key",
																						"operator",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																			matchLabels: {
																				additionalProperties: type: "string"
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
															git: {
																properties: {
																	directories: {
																		items: {
																			properties: {
																				exclude: type: "boolean"
																				path: type: "string"
																			}
																			required: ["path"]
																			type: "object"
																		}
																		type: "array"
																	}
																	files: {
																		items: {
																			properties: path: type: "string"
																			required: ["path"]
																			type: "object"
																		}
																		type: "array"
																	}
																	pathParamPrefix: type: "string"
																	repoURL: type: "string"
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	revision: type: "string"
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: [
																	"repoURL",
																	"revision",
																]
																type: "object"
															}
															list: {
																properties: {
																	elements: {
																		items: "x-kubernetes-preserve-unknown-fields": true
																		type: "array"
																	}
																	elementsYaml: type: "string"
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																}
																required: ["elements"]
																type: "object"
															}
															matrix: "x-kubernetes-preserve-unknown-fields": true
															merge: "x-kubernetes-preserve-unknown-fields": true
															plugin: {
																properties: {
																	configMapRef: {
																		properties: name: type: "string"
																		required: ["name"]
																		type: "object"
																	}
																	input: {
																		properties: parameters: {
																			additionalProperties: "x-kubernetes-preserve-unknown-fields": true
																			type: "object"
																		}
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: ["configMapRef"]
																type: "object"
															}
															pullRequest: {
																properties: {
																	azuredevops: {
																		properties: {
																			api: type: "string"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			organization: type: "string"
																			project: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"organization",
																			"project",
																			"repo",
																		]
																		type: "object"
																	}
																	bitbucket: {
																		properties: {
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			bearerToken: {
																				properties: tokenRef: {
																					properties: {
																						key: type: "string"
																						secretName: type: "string"
																					}
																					required: [
																						"key",
																						"secretName",
																					]
																					type: "object"
																				}
																				required: ["tokenRef"]
																				type: "object"
																			}
																			owner: type: "string"
																			repo: type: "string"
																		}
																		required: [
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	bitbucketServer: {
																		properties: {
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			project: type: "string"
																			repo: type: "string"
																		}
																		required: [
																			"api",
																			"project",
																			"repo",
																		]
																		type: "object"
																	}
																	filters: {
																		items: {
																			properties: {
																				branchMatch: type: "string"
																				targetBranchMatch: type: "string"
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	gitea: {
																		properties: {
																			api: type: "string"
																			insecure: type: "boolean"
																			owner: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"api",
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	github: {
																		properties: {
																			api: type: "string"
																			appSecretName: type: "string"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			owner: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	gitlab: {
																		properties: {
																			api: type: "string"
																			insecure: type: "boolean"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			project: type: "string"
																			pullRequestState: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: ["project"]
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																}
																type: "object"
															}
															scmProvider: {
																properties: {
																	awsCodeCommit: {
																		properties: {
																			allBranches: type: "boolean"
																			region: type: "string"
																			role: type: "string"
																			tagFilters: {
																				items: {
																					properties: {
																						key: type: "string"
																						value: type: "string"
																					}
																					required: ["key"]
																					type: "object"
																				}
																				type: "array"
																			}
																		}
																		type: "object"
																	}
																	azureDevOps: {
																		properties: {
																			accessTokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			allBranches: type: "boolean"
																			api: type: "string"
																			organization: type: "string"
																			teamProject: type: "string"
																		}
																		required: [
																			"accessTokenRef",
																			"organization",
																			"teamProject",
																		]
																		type: "object"
																	}
																	bitbucket: {
																		properties: {
																			allBranches: type: "boolean"
																			appPasswordRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			owner: type: "string"
																			user: type: "string"
																		}
																		required: [
																			"appPasswordRef",
																			"owner",
																			"user",
																		]
																		type: "object"
																	}
																	bitbucketServer: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			project: type: "string"
																		}
																		required: [
																			"api",
																			"project",
																		]
																		type: "object"
																	}
																	cloneProtocol: type: "string"
																	filters: {
																		items: {
																			properties: {
																				branchMatch: type: "string"
																				labelMatch: type: "string"
																				pathsDoNotExist: {
																					items: type: "string"
																					type: "array"
																				}
																				pathsExist: {
																					items: type: "string"
																					type: "array"
																				}
																				repositoryMatch: type: "string"
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	gitea: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			insecure: type: "boolean"
																			owner: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"api",
																			"owner",
																		]
																		type: "object"
																	}
																	github: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			appSecretName: type: "string"
																			organization: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: ["organization"]
																		type: "object"
																	}
																	gitlab: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			group: type: "string"
																			includeSharedProjects: type: "boolean"
																			includeSubgroups: type: "boolean"
																			insecure: type: "boolean"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			topic: type: "string"
																		}
																		required: ["group"]
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
															selector: {
																properties: {
																	matchExpressions: {
																		items: {
																			properties: {
																				key: type: "string"
																				operator: type: "string"
																				values: {
																					items: type: "string"
																					type: "array"
																				}
																			}
																			required: [
																				"key",
																				"operator",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	matchLabels: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													type: "array"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
											}
											required: ["generators"]
											type: "object"
										}
										merge: {
											properties: {
												generators: {
													items: {
														properties: {
															clusterDecisionResource: {
																properties: {
																	configMapRef: type: "string"
																	labelSelector: {
																		properties: {
																			matchExpressions: {
																				items: {
																					properties: {
																						key: type: "string"
																						operator: type: "string"
																						values: {
																							items: type: "string"
																							type: "array"
																						}
																					}
																					required: [
																						"key",
																						"operator",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																			matchLabels: {
																				additionalProperties: type: "string"
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	name: type: "string"
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: ["configMapRef"]
																type: "object"
															}
															clusters: {
																properties: {
																	selector: {
																		properties: {
																			matchExpressions: {
																				items: {
																					properties: {
																						key: type: "string"
																						operator: type: "string"
																						values: {
																							items: type: "string"
																							type: "array"
																						}
																					}
																					required: [
																						"key",
																						"operator",
																					]
																					type: "object"
																				}
																				type: "array"
																			}
																			matchLabels: {
																				additionalProperties: type: "string"
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
															git: {
																properties: {
																	directories: {
																		items: {
																			properties: {
																				exclude: type: "boolean"
																				path: type: "string"
																			}
																			required: ["path"]
																			type: "object"
																		}
																		type: "array"
																	}
																	files: {
																		items: {
																			properties: path: type: "string"
																			required: ["path"]
																			type: "object"
																		}
																		type: "array"
																	}
																	pathParamPrefix: type: "string"
																	repoURL: type: "string"
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	revision: type: "string"
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: [
																	"repoURL",
																	"revision",
																]
																type: "object"
															}
															list: {
																properties: {
																	elements: {
																		items: "x-kubernetes-preserve-unknown-fields": true
																		type: "array"
																	}
																	elementsYaml: type: "string"
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																}
																required: ["elements"]
																type: "object"
															}
															matrix: "x-kubernetes-preserve-unknown-fields": true
															merge: "x-kubernetes-preserve-unknown-fields": true
															plugin: {
																properties: {
																	configMapRef: {
																		properties: name: type: "string"
																		required: ["name"]
																		type: "object"
																	}
																	input: {
																		properties: parameters: {
																			additionalProperties: "x-kubernetes-preserve-unknown-fields": true
																			type: "object"
																		}
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																required: ["configMapRef"]
																type: "object"
															}
															pullRequest: {
																properties: {
																	azuredevops: {
																		properties: {
																			api: type: "string"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			organization: type: "string"
																			project: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"organization",
																			"project",
																			"repo",
																		]
																		type: "object"
																	}
																	bitbucket: {
																		properties: {
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			bearerToken: {
																				properties: tokenRef: {
																					properties: {
																						key: type: "string"
																						secretName: type: "string"
																					}
																					required: [
																						"key",
																						"secretName",
																					]
																					type: "object"
																				}
																				required: ["tokenRef"]
																				type: "object"
																			}
																			owner: type: "string"
																			repo: type: "string"
																		}
																		required: [
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	bitbucketServer: {
																		properties: {
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			project: type: "string"
																			repo: type: "string"
																		}
																		required: [
																			"api",
																			"project",
																			"repo",
																		]
																		type: "object"
																	}
																	filters: {
																		items: {
																			properties: {
																				branchMatch: type: "string"
																				targetBranchMatch: type: "string"
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	gitea: {
																		properties: {
																			api: type: "string"
																			insecure: type: "boolean"
																			owner: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"api",
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	github: {
																		properties: {
																			api: type: "string"
																			appSecretName: type: "string"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			owner: type: "string"
																			repo: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"owner",
																			"repo",
																		]
																		type: "object"
																	}
																	gitlab: {
																		properties: {
																			api: type: "string"
																			insecure: type: "boolean"
																			labels: {
																				items: type: "string"
																				type: "array"
																			}
																			project: type: "string"
																			pullRequestState: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: ["project"]
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																}
																type: "object"
															}
															scmProvider: {
																properties: {
																	awsCodeCommit: {
																		properties: {
																			allBranches: type: "boolean"
																			region: type: "string"
																			role: type: "string"
																			tagFilters: {
																				items: {
																					properties: {
																						key: type: "string"
																						value: type: "string"
																					}
																					required: ["key"]
																					type: "object"
																				}
																				type: "array"
																			}
																		}
																		type: "object"
																	}
																	azureDevOps: {
																		properties: {
																			accessTokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			allBranches: type: "boolean"
																			api: type: "string"
																			organization: type: "string"
																			teamProject: type: "string"
																		}
																		required: [
																			"accessTokenRef",
																			"organization",
																			"teamProject",
																		]
																		type: "object"
																	}
																	bitbucket: {
																		properties: {
																			allBranches: type: "boolean"
																			appPasswordRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			owner: type: "string"
																			user: type: "string"
																		}
																		required: [
																			"appPasswordRef",
																			"owner",
																			"user",
																		]
																		type: "object"
																	}
																	bitbucketServer: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			basicAuth: {
																				properties: {
																					passwordRef: {
																						properties: {
																							key: type: "string"
																							secretName: type: "string"
																						}
																						required: [
																							"key",
																							"secretName",
																						]
																						type: "object"
																					}
																					username: type: "string"
																				}
																				required: [
																					"passwordRef",
																					"username",
																				]
																				type: "object"
																			}
																			project: type: "string"
																		}
																		required: [
																			"api",
																			"project",
																		]
																		type: "object"
																	}
																	cloneProtocol: type: "string"
																	filters: {
																		items: {
																			properties: {
																				branchMatch: type: "string"
																				labelMatch: type: "string"
																				pathsDoNotExist: {
																					items: type: "string"
																					type: "array"
																				}
																				pathsExist: {
																					items: type: "string"
																					type: "array"
																				}
																				repositoryMatch: type: "string"
																			}
																			type: "object"
																		}
																		type: "array"
																	}
																	gitea: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			insecure: type: "boolean"
																			owner: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"api",
																			"owner",
																		]
																		type: "object"
																	}
																	github: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			appSecretName: type: "string"
																			organization: type: "string"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																		}
																		required: ["organization"]
																		type: "object"
																	}
																	gitlab: {
																		properties: {
																			allBranches: type: "boolean"
																			api: type: "string"
																			group: type: "string"
																			includeSharedProjects: type: "boolean"
																			includeSubgroups: type: "boolean"
																			insecure: type: "boolean"
																			tokenRef: {
																				properties: {
																					key: type: "string"
																					secretName: type: "string"
																				}
																				required: [
																					"key",
																					"secretName",
																				]
																				type: "object"
																			}
																			topic: type: "string"
																		}
																		required: ["group"]
																		type: "object"
																	}
																	requeueAfterSeconds: {
																		format: "int64"
																		type:   "integer"
																	}
																	template: {
																		properties: {
																			metadata: {
																				properties: {
																					annotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					finalizers: {
																						items: type: "string"
																						type: "array"
																					}
																					labels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					name: type: "string"
																					namespace: type: "string"
																				}
																				type: "object"
																			}
																			spec: {
																				properties: {
																					destination: {
																						properties: {
																							name: type: "string"
																							namespace: type: "string"
																							server: type: "string"
																						}
																						type: "object"
																					}
																					ignoreDifferences: {
																						items: {
																							properties: {
																								group: type: "string"
																								jqPathExpressions: {
																									items: type: "string"
																									type: "array"
																								}
																								jsonPointers: {
																									items: type: "string"
																									type: "array"
																								}
																								kind: type: "string"
																								managedFieldsManagers: {
																									items: type: "string"
																									type: "array"
																								}
																								name: type: "string"
																								namespace: type: "string"
																							}
																							required: ["kind"]
																							type: "object"
																						}
																						type: "array"
																					}
																					info: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					project: type: "string"
																					revisionHistoryLimit: {
																						format: "int64"
																						type:   "integer"
																					}
																					source: {
																						properties: {
																							chart: type: "string"
																							directory: {
																								properties: {
																									exclude: type: "string"
																									include: type: "string"
																									jsonnet: {
																										properties: {
																											extVars: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																											libs: {
																												items: type: "string"
																												type: "array"
																											}
																											tlas: {
																												items: {
																													properties: {
																														code: type: "boolean"
																														name: type: "string"
																														value: type: "string"
																													}
																													required: [
																														"name",
																														"value",
																													]
																													type: "object"
																												}
																												type: "array"
																											}
																										}
																										type: "object"
																									}
																									recurse: type: "boolean"
																								}
																								type: "object"
																							}
																							helm: {
																								properties: {
																									fileParameters: {
																										items: {
																											properties: {
																												name: type: "string"
																												path: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									ignoreMissingValueFiles: type: "boolean"
																									parameters: {
																										items: {
																											properties: {
																												forceString: type: "boolean"
																												name: type: "string"
																												value: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									passCredentials: type: "boolean"
																									releaseName: type: "string"
																									skipCrds: type: "boolean"
																									valueFiles: {
																										items: type: "string"
																										type: "array"
																									}
																									values: type: "string"
																									valuesObject: {
																										type:                                   "object"
																										"x-kubernetes-preserve-unknown-fields": true
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							kustomize: {
																								properties: {
																									commonAnnotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									commonAnnotationsEnvsubst: type: "boolean"
																									commonLabels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									components: {
																										items: type: "string"
																										type: "array"
																									}
																									forceCommonAnnotations: type: "boolean"
																									forceCommonLabels: type: "boolean"
																									images: {
																										items: type: "string"
																										type: "array"
																									}
																									namePrefix: type: "string"
																									nameSuffix: type: "string"
																									namespace: type: "string"
																									patches: {
																										items: {
																											properties: {
																												options: {
																													additionalProperties: type: "boolean"
																													type: "object"
																												}
																												patch: type: "string"
																												path: type: "string"
																												target: {
																													properties: {
																														annotationSelector: type: "string"
																														group: type: "string"
																														kind: type: "string"
																														labelSelector: type: "string"
																														name: type: "string"
																														namespace: type: "string"
																														version: type: "string"
																													}
																													type: "object"
																												}
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																									replicas: {
																										items: {
																											properties: {
																												count: {
																													anyOf: [{
																														type: "integer"
																													}, {
																														type: "string"
																													}]
																													"x-kubernetes-int-or-string": true
																												}
																												name: type: "string"
																											}
																											required: [
																												"count",
																												"name",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									version: type: "string"
																								}
																								type: "object"
																							}
																							path: type: "string"
																							plugin: {
																								properties: {
																									env: {
																										items: {
																											properties: {
																												name: type: "string"
																												value: type: "string"
																											}
																											required: [
																												"name",
																												"value",
																											]
																											type: "object"
																										}
																										type: "array"
																									}
																									name: type: "string"
																									parameters: {
																										items: {
																											properties: {
																												array: {
																													items: type: "string"
																													type: "array"
																												}
																												map: {
																													additionalProperties: type: "string"
																													type: "object"
																												}
																												name: type: "string"
																												string: type: "string"
																											}
																											type: "object"
																										}
																										type: "array"
																									}
																								}
																								type: "object"
																							}
																							ref: type: "string"
																							repoURL: type: "string"
																							targetRevision: type: "string"
																						}
																						required: ["repoURL"]
																						type: "object"
																					}
																					sources: {
																						items: {
																							properties: {
																								chart: type: "string"
																								directory: {
																									properties: {
																										exclude: type: "string"
																										include: type: "string"
																										jsonnet: {
																											properties: {
																												extVars: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																												libs: {
																													items: type: "string"
																													type: "array"
																												}
																												tlas: {
																													items: {
																														properties: {
																															code: type: "boolean"
																															name: type: "string"
																															value: type: "string"
																														}
																														required: [
																															"name",
																															"value",
																														]
																														type: "object"
																													}
																													type: "array"
																												}
																											}
																											type: "object"
																										}
																										recurse: type: "boolean"
																									}
																									type: "object"
																								}
																								helm: {
																									properties: {
																										fileParameters: {
																											items: {
																												properties: {
																													name: type: "string"
																													path: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										ignoreMissingValueFiles: type: "boolean"
																										parameters: {
																											items: {
																												properties: {
																													forceString: type: "boolean"
																													name: type: "string"
																													value: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										passCredentials: type: "boolean"
																										releaseName: type: "string"
																										skipCrds: type: "boolean"
																										valueFiles: {
																											items: type: "string"
																											type: "array"
																										}
																										values: type: "string"
																										valuesObject: {
																											type:                                   "object"
																											"x-kubernetes-preserve-unknown-fields": true
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								kustomize: {
																									properties: {
																										commonAnnotations: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										commonAnnotationsEnvsubst: type: "boolean"
																										commonLabels: {
																											additionalProperties: type: "string"
																											type: "object"
																										}
																										components: {
																											items: type: "string"
																											type: "array"
																										}
																										forceCommonAnnotations: type: "boolean"
																										forceCommonLabels: type: "boolean"
																										images: {
																											items: type: "string"
																											type: "array"
																										}
																										namePrefix: type: "string"
																										nameSuffix: type: "string"
																										namespace: type: "string"
																										patches: {
																											items: {
																												properties: {
																													options: {
																														additionalProperties: type: "boolean"
																														type: "object"
																													}
																													patch: type: "string"
																													path: type: "string"
																													target: {
																														properties: {
																															annotationSelector: type: "string"
																															group: type: "string"
																															kind: type: "string"
																															labelSelector: type: "string"
																															name: type: "string"
																															namespace: type: "string"
																															version: type: "string"
																														}
																														type: "object"
																													}
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																										replicas: {
																											items: {
																												properties: {
																													count: {
																														anyOf: [{
																															type: "integer"
																														}, {
																															type: "string"
																														}]
																														"x-kubernetes-int-or-string": true
																													}
																													name: type: "string"
																												}
																												required: [
																													"count",
																													"name",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										version: type: "string"
																									}
																									type: "object"
																								}
																								path: type: "string"
																								plugin: {
																									properties: {
																										env: {
																											items: {
																												properties: {
																													name: type: "string"
																													value: type: "string"
																												}
																												required: [
																													"name",
																													"value",
																												]
																												type: "object"
																											}
																											type: "array"
																										}
																										name: type: "string"
																										parameters: {
																											items: {
																												properties: {
																													array: {
																														items: type: "string"
																														type: "array"
																													}
																													map: {
																														additionalProperties: type: "string"
																														type: "object"
																													}
																													name: type: "string"
																													string: type: "string"
																												}
																												type: "object"
																											}
																											type: "array"
																										}
																									}
																									type: "object"
																								}
																								ref: type: "string"
																								repoURL: type: "string"
																								targetRevision: type: "string"
																							}
																							required: ["repoURL"]
																							type: "object"
																						}
																						type: "array"
																					}
																					syncPolicy: {
																						properties: {
																							automated: {
																								properties: {
																									allowEmpty: type: "boolean"
																									prune: type: "boolean"
																									selfHeal: type: "boolean"
																								}
																								type: "object"
																							}
																							managedNamespaceMetadata: {
																								properties: {
																									annotations: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																									labels: {
																										additionalProperties: type: "string"
																										type: "object"
																									}
																								}
																								type: "object"
																							}
																							retry: {
																								properties: {
																									backoff: {
																										properties: {
																											duration: type: "string"
																											factor: {
																												format: "int64"
																												type:   "integer"
																											}
																											maxDuration: type: "string"
																										}
																										type: "object"
																									}
																									limit: {
																										format: "int64"
																										type:   "integer"
																									}
																								}
																								type: "object"
																							}
																							syncOptions: {
																								items: type: "string"
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																				}
																				required: [
																					"destination",
																					"project",
																				]
																				type: "object"
																			}
																		}
																		required: [
																			"metadata",
																			"spec",
																		]
																		type: "object"
																	}
																	values: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
															selector: {
																properties: {
																	matchExpressions: {
																		items: {
																			properties: {
																				key: type: "string"
																				operator: type: "string"
																				values: {
																					items: type: "string"
																					type: "array"
																				}
																			}
																			required: [
																				"key",
																				"operator",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	matchLabels: {
																		additionalProperties: type: "string"
																		type: "object"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													type: "array"
												}
												mergeKeys: {
													items: type: "string"
													type: "array"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
											}
											required: [
												"generators",
												"mergeKeys",
											]
											type: "object"
										}
										plugin: {
											properties: {
												configMapRef: {
													properties: name: type: "string"
													required: ["name"]
													type: "object"
												}
												input: {
													properties: parameters: {
														additionalProperties: "x-kubernetes-preserve-unknown-fields": true
														type: "object"
													}
													type: "object"
												}
												requeueAfterSeconds: {
													format: "int64"
													type:   "integer"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
												values: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											required: ["configMapRef"]
											type: "object"
										}
										pullRequest: {
											properties: {
												azuredevops: {
													properties: {
														api: type: "string"
														labels: {
															items: type: "string"
															type: "array"
														}
														organization: type: "string"
														project: type: "string"
														repo: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: [
														"organization",
														"project",
														"repo",
													]
													type: "object"
												}
												bitbucket: {
													properties: {
														api: type: "string"
														basicAuth: {
															properties: {
																passwordRef: {
																	properties: {
																		key: type: "string"
																		secretName: type: "string"
																	}
																	required: [
																		"key",
																		"secretName",
																	]
																	type: "object"
																}
																username: type: "string"
															}
															required: [
																"passwordRef",
																"username",
															]
															type: "object"
														}
														bearerToken: {
															properties: tokenRef: {
																properties: {
																	key: type: "string"
																	secretName: type: "string"
																}
																required: [
																	"key",
																	"secretName",
																]
																type: "object"
															}
															required: ["tokenRef"]
															type: "object"
														}
														owner: type: "string"
														repo: type: "string"
													}
													required: [
														"owner",
														"repo",
													]
													type: "object"
												}
												bitbucketServer: {
													properties: {
														api: type: "string"
														basicAuth: {
															properties: {
																passwordRef: {
																	properties: {
																		key: type: "string"
																		secretName: type: "string"
																	}
																	required: [
																		"key",
																		"secretName",
																	]
																	type: "object"
																}
																username: type: "string"
															}
															required: [
																"passwordRef",
																"username",
															]
															type: "object"
														}
														project: type: "string"
														repo: type: "string"
													}
													required: [
														"api",
														"project",
														"repo",
													]
													type: "object"
												}
												filters: {
													items: {
														properties: {
															branchMatch: type: "string"
															targetBranchMatch: type: "string"
														}
														type: "object"
													}
													type: "array"
												}
												gitea: {
													properties: {
														api: type: "string"
														insecure: type: "boolean"
														owner: type: "string"
														repo: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: [
														"api",
														"owner",
														"repo",
													]
													type: "object"
												}
												github: {
													properties: {
														api: type: "string"
														appSecretName: type: "string"
														labels: {
															items: type: "string"
															type: "array"
														}
														owner: type: "string"
														repo: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: [
														"owner",
														"repo",
													]
													type: "object"
												}
												gitlab: {
													properties: {
														api: type: "string"
														insecure: type: "boolean"
														labels: {
															items: type: "string"
															type: "array"
														}
														project: type: "string"
														pullRequestState: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: ["project"]
													type: "object"
												}
												requeueAfterSeconds: {
													format: "int64"
													type:   "integer"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
											}
											type: "object"
										}
										scmProvider: {
											properties: {
												awsCodeCommit: {
													properties: {
														allBranches: type: "boolean"
														region: type: "string"
														role: type: "string"
														tagFilters: {
															items: {
																properties: {
																	key: type: "string"
																	value: type: "string"
																}
																required: ["key"]
																type: "object"
															}
															type: "array"
														}
													}
													type: "object"
												}
												azureDevOps: {
													properties: {
														accessTokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
														allBranches: type: "boolean"
														api: type: "string"
														organization: type: "string"
														teamProject: type: "string"
													}
													required: [
														"accessTokenRef",
														"organization",
														"teamProject",
													]
													type: "object"
												}
												bitbucket: {
													properties: {
														allBranches: type: "boolean"
														appPasswordRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
														owner: type: "string"
														user: type: "string"
													}
													required: [
														"appPasswordRef",
														"owner",
														"user",
													]
													type: "object"
												}
												bitbucketServer: {
													properties: {
														allBranches: type: "boolean"
														api: type: "string"
														basicAuth: {
															properties: {
																passwordRef: {
																	properties: {
																		key: type: "string"
																		secretName: type: "string"
																	}
																	required: [
																		"key",
																		"secretName",
																	]
																	type: "object"
																}
																username: type: "string"
															}
															required: [
																"passwordRef",
																"username",
															]
															type: "object"
														}
														project: type: "string"
													}
													required: [
														"api",
														"project",
													]
													type: "object"
												}
												cloneProtocol: type: "string"
												filters: {
													items: {
														properties: {
															branchMatch: type: "string"
															labelMatch: type: "string"
															pathsDoNotExist: {
																items: type: "string"
																type: "array"
															}
															pathsExist: {
																items: type: "string"
																type: "array"
															}
															repositoryMatch: type: "string"
														}
														type: "object"
													}
													type: "array"
												}
												gitea: {
													properties: {
														allBranches: type: "boolean"
														api: type: "string"
														insecure: type: "boolean"
														owner: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: [
														"api",
														"owner",
													]
													type: "object"
												}
												github: {
													properties: {
														allBranches: type: "boolean"
														api: type: "string"
														appSecretName: type: "string"
														organization: type: "string"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
													}
													required: ["organization"]
													type: "object"
												}
												gitlab: {
													properties: {
														allBranches: type: "boolean"
														api: type: "string"
														group: type: "string"
														includeSharedProjects: type: "boolean"
														includeSubgroups: type: "boolean"
														insecure: type: "boolean"
														tokenRef: {
															properties: {
																key: type: "string"
																secretName: type: "string"
															}
															required: [
																"key",
																"secretName",
															]
															type: "object"
														}
														topic: type: "string"
													}
													required: ["group"]
													type: "object"
												}
												requeueAfterSeconds: {
													format: "int64"
													type:   "integer"
												}
												template: {
													properties: {
														metadata: {
															properties: {
																annotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																finalizers: {
																	items: type: "string"
																	type: "array"
																}
																labels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																name: type: "string"
																namespace: type: "string"
															}
															type: "object"
														}
														spec: {
															properties: {
																destination: {
																	properties: {
																		name: type: "string"
																		namespace: type: "string"
																		server: type: "string"
																	}
																	type: "object"
																}
																ignoreDifferences: {
																	items: {
																		properties: {
																			group: type: "string"
																			jqPathExpressions: {
																				items: type: "string"
																				type: "array"
																			}
																			jsonPointers: {
																				items: type: "string"
																				type: "array"
																			}
																			kind: type: "string"
																			managedFieldsManagers: {
																				items: type: "string"
																				type: "array"
																			}
																			name: type: "string"
																			namespace: type: "string"
																		}
																		required: ["kind"]
																		type: "object"
																	}
																	type: "array"
																}
																info: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																project: type: "string"
																revisionHistoryLimit: {
																	format: "int64"
																	type:   "integer"
																}
																source: {
																	properties: {
																		chart: type: "string"
																		directory: {
																			properties: {
																				exclude: type: "string"
																				include: type: "string"
																				jsonnet: {
																					properties: {
																						extVars: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																						libs: {
																							items: type: "string"
																							type: "array"
																						}
																						tlas: {
																							items: {
																								properties: {
																									code: type: "boolean"
																									name: type: "string"
																									value: type: "string"
																								}
																								required: [
																									"name",
																									"value",
																								]
																								type: "object"
																							}
																							type: "array"
																						}
																					}
																					type: "object"
																				}
																				recurse: type: "boolean"
																			}
																			type: "object"
																		}
																		helm: {
																			properties: {
																				fileParameters: {
																					items: {
																						properties: {
																							name: type: "string"
																							path: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				ignoreMissingValueFiles: type: "boolean"
																				parameters: {
																					items: {
																						properties: {
																							forceString: type: "boolean"
																							name: type: "string"
																							value: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				passCredentials: type: "boolean"
																				releaseName: type: "string"
																				skipCrds: type: "boolean"
																				valueFiles: {
																					items: type: "string"
																					type: "array"
																				}
																				values: type: "string"
																				valuesObject: {
																					type:                                   "object"
																					"x-kubernetes-preserve-unknown-fields": true
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		kustomize: {
																			properties: {
																				commonAnnotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				commonAnnotationsEnvsubst: type: "boolean"
																				commonLabels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				components: {
																					items: type: "string"
																					type: "array"
																				}
																				forceCommonAnnotations: type: "boolean"
																				forceCommonLabels: type: "boolean"
																				images: {
																					items: type: "string"
																					type: "array"
																				}
																				namePrefix: type: "string"
																				nameSuffix: type: "string"
																				namespace: type: "string"
																				patches: {
																					items: {
																						properties: {
																							options: {
																								additionalProperties: type: "boolean"
																								type: "object"
																							}
																							patch: type: "string"
																							path: type: "string"
																							target: {
																								properties: {
																									annotationSelector: type: "string"
																									group: type: "string"
																									kind: type: "string"
																									labelSelector: type: "string"
																									name: type: "string"
																									namespace: type: "string"
																									version: type: "string"
																								}
																								type: "object"
																							}
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																				replicas: {
																					items: {
																						properties: {
																							count: {
																								anyOf: [{
																									type: "integer"
																								}, {
																									type: "string"
																								}]
																								"x-kubernetes-int-or-string": true
																							}
																							name: type: "string"
																						}
																						required: [
																							"count",
																							"name",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				version: type: "string"
																			}
																			type: "object"
																		}
																		path: type: "string"
																		plugin: {
																			properties: {
																				env: {
																					items: {
																						properties: {
																							name: type: "string"
																							value: type: "string"
																						}
																						required: [
																							"name",
																							"value",
																						]
																						type: "object"
																					}
																					type: "array"
																				}
																				name: type: "string"
																				parameters: {
																					items: {
																						properties: {
																							array: {
																								items: type: "string"
																								type: "array"
																							}
																							map: {
																								additionalProperties: type: "string"
																								type: "object"
																							}
																							name: type: "string"
																							string: type: "string"
																						}
																						type: "object"
																					}
																					type: "array"
																				}
																			}
																			type: "object"
																		}
																		ref: type: "string"
																		repoURL: type: "string"
																		targetRevision: type: "string"
																	}
																	required: ["repoURL"]
																	type: "object"
																}
																sources: {
																	items: {
																		properties: {
																			chart: type: "string"
																			directory: {
																				properties: {
																					exclude: type: "string"
																					include: type: "string"
																					jsonnet: {
																						properties: {
																							extVars: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																							libs: {
																								items: type: "string"
																								type: "array"
																							}
																							tlas: {
																								items: {
																									properties: {
																										code: type: "boolean"
																										name: type: "string"
																										value: type: "string"
																									}
																									required: [
																										"name",
																										"value",
																									]
																									type: "object"
																								}
																								type: "array"
																							}
																						}
																						type: "object"
																					}
																					recurse: type: "boolean"
																				}
																				type: "object"
																			}
																			helm: {
																				properties: {
																					fileParameters: {
																						items: {
																							properties: {
																								name: type: "string"
																								path: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					ignoreMissingValueFiles: type: "boolean"
																					parameters: {
																						items: {
																							properties: {
																								forceString: type: "boolean"
																								name: type: "string"
																								value: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					passCredentials: type: "boolean"
																					releaseName: type: "string"
																					skipCrds: type: "boolean"
																					valueFiles: {
																						items: type: "string"
																						type: "array"
																					}
																					values: type: "string"
																					valuesObject: {
																						type:                                   "object"
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			kustomize: {
																				properties: {
																					commonAnnotations: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					commonAnnotationsEnvsubst: type: "boolean"
																					commonLabels: {
																						additionalProperties: type: "string"
																						type: "object"
																					}
																					components: {
																						items: type: "string"
																						type: "array"
																					}
																					forceCommonAnnotations: type: "boolean"
																					forceCommonLabels: type: "boolean"
																					images: {
																						items: type: "string"
																						type: "array"
																					}
																					namePrefix: type: "string"
																					nameSuffix: type: "string"
																					namespace: type: "string"
																					patches: {
																						items: {
																							properties: {
																								options: {
																									additionalProperties: type: "boolean"
																									type: "object"
																								}
																								patch: type: "string"
																								path: type: "string"
																								target: {
																									properties: {
																										annotationSelector: type: "string"
																										group: type: "string"
																										kind: type: "string"
																										labelSelector: type: "string"
																										name: type: "string"
																										namespace: type: "string"
																										version: type: "string"
																									}
																									type: "object"
																								}
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																					replicas: {
																						items: {
																							properties: {
																								count: {
																									anyOf: [{
																										type: "integer"
																									}, {
																										type: "string"
																									}]
																									"x-kubernetes-int-or-string": true
																								}
																								name: type: "string"
																							}
																							required: [
																								"count",
																								"name",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					version: type: "string"
																				}
																				type: "object"
																			}
																			path: type: "string"
																			plugin: {
																				properties: {
																					env: {
																						items: {
																							properties: {
																								name: type: "string"
																								value: type: "string"
																							}
																							required: [
																								"name",
																								"value",
																							]
																							type: "object"
																						}
																						type: "array"
																					}
																					name: type: "string"
																					parameters: {
																						items: {
																							properties: {
																								array: {
																									items: type: "string"
																									type: "array"
																								}
																								map: {
																									additionalProperties: type: "string"
																									type: "object"
																								}
																								name: type: "string"
																								string: type: "string"
																							}
																							type: "object"
																						}
																						type: "array"
																					}
																				}
																				type: "object"
																			}
																			ref: type: "string"
																			repoURL: type: "string"
																			targetRevision: type: "string"
																		}
																		required: ["repoURL"]
																		type: "object"
																	}
																	type: "array"
																}
																syncPolicy: {
																	properties: {
																		automated: {
																			properties: {
																				allowEmpty: type: "boolean"
																				prune: type: "boolean"
																				selfHeal: type: "boolean"
																			}
																			type: "object"
																		}
																		managedNamespaceMetadata: {
																			properties: {
																				annotations: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																				labels: {
																					additionalProperties: type: "string"
																					type: "object"
																				}
																			}
																			type: "object"
																		}
																		retry: {
																			properties: {
																				backoff: {
																					properties: {
																						duration: type: "string"
																						factor: {
																							format: "int64"
																							type:   "integer"
																						}
																						maxDuration: type: "string"
																					}
																					type: "object"
																				}
																				limit: {
																					format: "int64"
																					type:   "integer"
																				}
																			}
																			type: "object"
																		}
																		syncOptions: {
																			items: type: "string"
																			type: "array"
																		}
																	}
																	type: "object"
																}
															}
															required: [
																"destination",
																"project",
															]
															type: "object"
														}
													}
													required: [
														"metadata",
														"spec",
													]
													type: "object"
												}
												values: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											type: "object"
										}
										selector: {
											properties: {
												matchExpressions: {
													items: {
														properties: {
															key: type: "string"
															operator: type: "string"
															values: {
																items: type: "string"
																type: "array"
															}
														}
														required: [
															"key",
															"operator",
														]
														type: "object"
													}
													type: "array"
												}
												matchLabels: {
													additionalProperties: type: "string"
													type: "object"
												}
											}
											type: "object"
										}
									}
									type: "object"
								}
								type: "array"
							}
							goTemplate: type: "boolean"
							goTemplateOptions: {
								items: type: "string"
								type: "array"
							}
							ignoreApplicationDifferences: {
								items: {
									properties: {
										jqPathExpressions: {
											items: type: "string"
											type: "array"
										}
										jsonPointers: {
											items: type: "string"
											type: "array"
										}
										name: type: "string"
									}
									type: "object"
								}
								type: "array"
							}
							preservedFields: {
								properties: {
									annotations: {
										items: type: "string"
										type: "array"
									}
									labels: {
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							strategy: {
								properties: {
									rollingSync: {
										properties: steps: {
											items: {
												properties: {
													matchExpressions: {
														items: {
															properties: {
																key: type: "string"
																operator: type: "string"
																values: {
																	items: type: "string"
																	type: "array"
																}
															}
															type: "object"
														}
														type: "array"
													}
													maxUpdate: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														"x-kubernetes-int-or-string": true
													}
												}
												type: "object"
											}
											type: "array"
										}
										type: "object"
									}
									type: type: "string"
								}
								type: "object"
							}
							syncPolicy: {
								properties: {
									applicationsSync: {
										enum: [
											"create-only",
											"create-update",
											"create-delete",
											"sync",
										]
										type: "string"
									}
									preserveResourcesOnDeletion: type: "boolean"
								}
								type: "object"
							}
							template: {
								properties: {
									metadata: {
										properties: {
											annotations: {
												additionalProperties: type: "string"
												type: "object"
											}
											finalizers: {
												items: type: "string"
												type: "array"
											}
											labels: {
												additionalProperties: type: "string"
												type: "object"
											}
											name: type: "string"
											namespace: type: "string"
										}
										type: "object"
									}
									spec: {
										properties: {
											destination: {
												properties: {
													name: type: "string"
													namespace: type: "string"
													server: type: "string"
												}
												type: "object"
											}
											ignoreDifferences: {
												items: {
													properties: {
														group: type: "string"
														jqPathExpressions: {
															items: type: "string"
															type: "array"
														}
														jsonPointers: {
															items: type: "string"
															type: "array"
														}
														kind: type: "string"
														managedFieldsManagers: {
															items: type: "string"
															type: "array"
														}
														name: type: "string"
														namespace: type: "string"
													}
													required: ["kind"]
													type: "object"
												}
												type: "array"
											}
											info: {
												items: {
													properties: {
														name: type: "string"
														value: type: "string"
													}
													required: [
														"name",
														"value",
													]
													type: "object"
												}
												type: "array"
											}
											project: type: "string"
											revisionHistoryLimit: {
												format: "int64"
												type:   "integer"
											}
											source: {
												properties: {
													chart: type: "string"
													directory: {
														properties: {
															exclude: type: "string"
															include: type: "string"
															jsonnet: {
																properties: {
																	extVars: {
																		items: {
																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																	libs: {
																		items: type: "string"
																		type: "array"
																	}
																	tlas: {
																		items: {
																			properties: {
																				code: type: "boolean"
																				name: type: "string"
																				value: type: "string"
																			}
																			required: [
																				"name",
																				"value",
																			]
																			type: "object"
																		}
																		type: "array"
																	}
																}
																type: "object"
															}
															recurse: type: "boolean"
														}
														type: "object"
													}
													helm: {
														properties: {
															fileParameters: {
																items: {
																	properties: {
																		name: type: "string"
																		path: type: "string"
																	}
																	type: "object"
																}
																type: "array"
															}
															ignoreMissingValueFiles: type: "boolean"
															parameters: {
																items: {
																	properties: {
																		forceString: type: "boolean"
																		name: type: "string"
																		value: type: "string"
																	}
																	type: "object"
																}
																type: "array"
															}
															passCredentials: type: "boolean"
															releaseName: type: "string"
															skipCrds: type: "boolean"
															valueFiles: {
																items: type: "string"
																type: "array"
															}
															values: type: "string"
															valuesObject: {
																type:                                   "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															version: type: "string"
														}
														type: "object"
													}
													kustomize: {
														properties: {
															commonAnnotations: {
																additionalProperties: type: "string"
																type: "object"
															}
															commonAnnotationsEnvsubst: type: "boolean"
															commonLabels: {
																additionalProperties: type: "string"
																type: "object"
															}
															components: {
																items: type: "string"
																type: "array"
															}
															forceCommonAnnotations: type: "boolean"
															forceCommonLabels: type: "boolean"
															images: {
																items: type: "string"
																type: "array"
															}
															namePrefix: type: "string"
															nameSuffix: type: "string"
															namespace: type: "string"
															patches: {
																items: {
																	properties: {
																		options: {
																			additionalProperties: type: "boolean"
																			type: "object"
																		}
																		patch: type: "string"
																		path: type: "string"
																		target: {
																			properties: {
																				annotationSelector: type: "string"
																				group: type: "string"
																				kind: type: "string"
																				labelSelector: type: "string"
																				name: type: "string"
																				namespace: type: "string"
																				version: type: "string"
																			}
																			type: "object"
																		}
																	}
																	type: "object"
																}
																type: "array"
															}
															replicas: {
																items: {
																	properties: {
																		count: {
																			anyOf: [{
																				type: "integer"
																			}, {
																				type: "string"
																			}]
																			"x-kubernetes-int-or-string": true
																		}
																		name: type: "string"
																	}
																	required: [
																		"count",
																		"name",
																	]
																	type: "object"
																}
																type: "array"
															}
															version: type: "string"
														}
														type: "object"
													}
													path: type: "string"
													plugin: {
														properties: {
															env: {
																items: {
																	properties: {
																		name: type: "string"
																		value: type: "string"
																	}
																	required: [
																		"name",
																		"value",
																	]
																	type: "object"
																}
																type: "array"
															}
															name: type: "string"
															parameters: {
																items: {
																	properties: {
																		array: {
																			items: type: "string"
																			type: "array"
																		}
																		map: {
																			additionalProperties: type: "string"
																			type: "object"
																		}
																		name: type: "string"
																		string: type: "string"
																	}
																	type: "object"
																}
																type: "array"
															}
														}
														type: "object"
													}
													ref: type: "string"
													repoURL: type: "string"
													targetRevision: type: "string"
												}
												required: ["repoURL"]
												type: "object"
											}
											sources: {
												items: {
													properties: {
														chart: type: "string"
														directory: {
															properties: {
																exclude: type: "string"
																include: type: "string"
																jsonnet: {
																	properties: {
																		extVars: {
																			items: {
																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																		libs: {
																			items: type: "string"
																			type: "array"
																		}
																		tlas: {
																			items: {
																				properties: {
																					code: type: "boolean"
																					name: type: "string"
																					value: type: "string"
																				}
																				required: [
																					"name",
																					"value",
																				]
																				type: "object"
																			}
																			type: "array"
																		}
																	}
																	type: "object"
																}
																recurse: type: "boolean"
															}
															type: "object"
														}
														helm: {
															properties: {
																fileParameters: {
																	items: {
																		properties: {
																			name: type: "string"
																			path: type: "string"
																		}
																		type: "object"
																	}
																	type: "array"
																}
																ignoreMissingValueFiles: type: "boolean"
																parameters: {
																	items: {
																		properties: {
																			forceString: type: "boolean"
																			name: type: "string"
																			value: type: "string"
																		}
																		type: "object"
																	}
																	type: "array"
																}
																passCredentials: type: "boolean"
																releaseName: type: "string"
																skipCrds: type: "boolean"
																valueFiles: {
																	items: type: "string"
																	type: "array"
																}
																values: type: "string"
																valuesObject: {
																	type:                                   "object"
																	"x-kubernetes-preserve-unknown-fields": true
																}
																version: type: "string"
															}
															type: "object"
														}
														kustomize: {
															properties: {
																commonAnnotations: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																commonAnnotationsEnvsubst: type: "boolean"
																commonLabels: {
																	additionalProperties: type: "string"
																	type: "object"
																}
																components: {
																	items: type: "string"
																	type: "array"
																}
																forceCommonAnnotations: type: "boolean"
																forceCommonLabels: type: "boolean"
																images: {
																	items: type: "string"
																	type: "array"
																}
																namePrefix: type: "string"
																nameSuffix: type: "string"
																namespace: type: "string"
																patches: {
																	items: {
																		properties: {
																			options: {
																				additionalProperties: type: "boolean"
																				type: "object"
																			}
																			patch: type: "string"
																			path: type: "string"
																			target: {
																				properties: {
																					annotationSelector: type: "string"
																					group: type: "string"
																					kind: type: "string"
																					labelSelector: type: "string"
																					name: type: "string"
																					namespace: type: "string"
																					version: type: "string"
																				}
																				type: "object"
																			}
																		}
																		type: "object"
																	}
																	type: "array"
																}
																replicas: {
																	items: {
																		properties: {
																			count: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				"x-kubernetes-int-or-string": true
																			}
																			name: type: "string"
																		}
																		required: [
																			"count",
																			"name",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																version: type: "string"
															}
															type: "object"
														}
														path: type: "string"
														plugin: {
															properties: {
																env: {
																	items: {
																		properties: {
																			name: type: "string"
																			value: type: "string"
																		}
																		required: [
																			"name",
																			"value",
																		]
																		type: "object"
																	}
																	type: "array"
																}
																name: type: "string"
																parameters: {
																	items: {
																		properties: {
																			array: {
																				items: type: "string"
																				type: "array"
																			}
																			map: {
																				additionalProperties: type: "string"
																				type: "object"
																			}
																			name: type: "string"
																			string: type: "string"
																		}
																		type: "object"
																	}
																	type: "array"
																}
															}
															type: "object"
														}
														ref: type: "string"
														repoURL: type: "string"
														targetRevision: type: "string"
													}
													required: ["repoURL"]
													type: "object"
												}
												type: "array"
											}
											syncPolicy: {
												properties: {
													automated: {
														properties: {
															allowEmpty: type: "boolean"
															prune: type: "boolean"
															selfHeal: type: "boolean"
														}
														type: "object"
													}
													managedNamespaceMetadata: {
														properties: {
															annotations: {
																additionalProperties: type: "string"
																type: "object"
															}
															labels: {
																additionalProperties: type: "string"
																type: "object"
															}
														}
														type: "object"
													}
													retry: {
														properties: {
															backoff: {
																properties: {
																	duration: type: "string"
																	factor: {
																		format: "int64"
																		type:   "integer"
																	}
																	maxDuration: type: "string"
																}
																type: "object"
															}
															limit: {
																format: "int64"
																type:   "integer"
															}
														}
														type: "object"
													}
													syncOptions: {
														items: type: "string"
														type: "array"
													}
												}
												type: "object"
											}
										}
										required: [
											"destination",
											"project",
										]
										type: "object"
									}
								}
								required: [
									"metadata",
									"spec",
								]
								type: "object"
							}
							templatePatch: type: "string"
						}
						required: [
							"generators",
							"template",
						]
						type: "object"
					}
					status: {
						properties: {
							applicationStatus: {
								items: {
									properties: {
										application: type: "string"
										lastTransitionTime: {
											format: "date-time"
											type:   "string"
										}
										message: type: "string"
										status: type: "string"
										step: type: "string"
									}
									required: [
										"application",
										"message",
										"status",
										"step",
									]
									type: "object"
								}
								type: "array"
							}
							conditions: {
								items: {
									properties: {
										lastTransitionTime: {
											format: "date-time"
											type:   "string"
										}
										message: type: "string"
										reason: type: "string"
										status: type: "string"
										type: type: "string"
									}
									required: [
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "appprojects.argoproj.io": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "appprojects.argoproj.io"
			"app.kubernetes.io/part-of": "argocd"
		}
		name: "appprojects.argoproj.io"
	}
	spec: {
		group: "argoproj.io"
		names: {
			kind:     "AppProject"
			listKind: "AppProjectList"
			plural:   "appprojects"
			shortNames: [
				"appproj",
				"appprojs",
			]
			singular: "appproject"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "AppProject provides a logical grouping of applications, providing controls for: * where the apps may deploy to (cluster whitelist) * what may be deployed (repository whitelist, resource whitelist/blacklist) * who can access these applications (roles, OIDC group claims bindings) * and what they can do (RBAC policies) * automation access to these roles (JWT tokens)"

				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "AppProjectSpec is the specification of an AppProject"
						properties: {
							clusterResourceBlacklist: {
								description: "ClusterResourceBlacklist contains list of blacklisted cluster level resources"

								items: {
									description: "GroupKind specifies a Group and a Kind, but does not force a version.  This is useful for identifying concepts during lookup stages without having partially valid types"

									properties: {
										group: type: "string"
										kind: type: "string"
									}
									required: [
										"group",
										"kind",
									]
									type: "object"
								}
								type: "array"
							}
							clusterResourceWhitelist: {
								description: "ClusterResourceWhitelist contains list of whitelisted cluster level resources"

								items: {
									description: "GroupKind specifies a Group and a Kind, but does not force a version.  This is useful for identifying concepts during lookup stages without having partially valid types"

									properties: {
										group: type: "string"
										kind: type: "string"
									}
									required: [
										"group",
										"kind",
									]
									type: "object"
								}
								type: "array"
							}
							description: {
								description: "Description contains optional project description"
								type:        "string"
							}
							destinations: {
								description: "Destinations contains list of destinations available for deployment"

								items: {
									description: "ApplicationDestination holds information about the application's destination"

									properties: {
										name: {
											description: "Name is an alternate way of specifying the target cluster by its symbolic name. This must be set if Server is not set."

											type: "string"
										}
										namespace: {
											description: "Namespace specifies the target namespace for the application's resources. The namespace will only be set for namespace-scoped resources that have not set a value for .metadata.namespace"

											type: "string"
										}
										server: {
											description: "Server specifies the URL of the target cluster's Kubernetes control plane API. This must be set if Name is not set."

											type: "string"
										}
									}
									type: "object"
								}
								type: "array"
							}
							namespaceResourceBlacklist: {
								description: "NamespaceResourceBlacklist contains list of blacklisted namespace level resources"

								items: {
									description: "GroupKind specifies a Group and a Kind, but does not force a version.  This is useful for identifying concepts during lookup stages without having partially valid types"

									properties: {
										group: type: "string"
										kind: type: "string"
									}
									required: [
										"group",
										"kind",
									]
									type: "object"
								}
								type: "array"
							}
							namespaceResourceWhitelist: {
								description: "NamespaceResourceWhitelist contains list of whitelisted namespace level resources"

								items: {
									description: "GroupKind specifies a Group and a Kind, but does not force a version.  This is useful for identifying concepts during lookup stages without having partially valid types"

									properties: {
										group: type: "string"
										kind: type: "string"
									}
									required: [
										"group",
										"kind",
									]
									type: "object"
								}
								type: "array"
							}
							orphanedResources: {
								description: "OrphanedResources specifies if controller should monitor orphaned resources of apps in this project"

								properties: {
									ignore: {
										description: "Ignore contains a list of resources that are to be excluded from orphaned resources monitoring"

										items: {
											description: "OrphanedResourceKey is a reference to a resource to be ignored from"

											properties: {
												group: type: "string"
												kind: type: "string"
												name: type: "string"
											}
											type: "object"
										}
										type: "array"
									}
									warn: {
										description: "Warn indicates if warning condition should be created for apps which have orphaned resources"

										type: "boolean"
									}
								}
								type: "object"
							}
							permitOnlyProjectScopedClusters: {
								description: "PermitOnlyProjectScopedClusters determines whether destinations can only reference clusters which are project-scoped"

								type: "boolean"
							}
							roles: {
								description: "Roles are user defined RBAC roles associated with this project"

								items: {
									description: "ProjectRole represents a role that has access to a project"

									properties: {
										description: {
											description: "Description is a description of the role"
											type:        "string"
										}
										groups: {
											description: "Groups are a list of OIDC group claims bound to this role"

											items: type: "string"
											type: "array"
										}
										jwtTokens: {
											description: "JWTTokens are a list of generated JWT tokens bound to this role"

											items: {
												description: "JWTToken holds the issuedAt and expiresAt values of a token"

												properties: {
													exp: {
														format: "int64"
														type:   "integer"
													}
													iat: {
														format: "int64"
														type:   "integer"
													}
													id: type: "string"
												}
												required: ["iat"]
												type: "object"
											}
											type: "array"
										}
										name: {
											description: "Name is a name for this role"
											type:        "string"
										}
										policies: {
											description: "Policies Stores a list of casbin formatted strings that define access policies for the role in the project"

											items: type: "string"
											type: "array"
										}
									}
									required: ["name"]
									type: "object"
								}
								type: "array"
							}
							signatureKeys: {
								description: "SignatureKeys contains a list of PGP key IDs that commits in Git must be signed with in order to be allowed for sync"

								items: {
									description: "SignatureKey is the specification of a key required to verify commit signatures with"

									properties: keyID: {
										description: "The ID of the key in hexadecimal notation"
										type:        "string"
									}
									required: ["keyID"]
									type: "object"
								}
								type: "array"
							}
							sourceNamespaces: {
								description: "SourceNamespaces defines the namespaces application resources are allowed to be created in"

								items: type: "string"
								type: "array"
							}
							sourceRepos: {
								description: "SourceRepos contains list of repository URLs which can be used for deployment"

								items: type: "string"
								type: "array"
							}
							syncWindows: {
								description: "SyncWindows controls when syncs can be run for apps in this project"

								items: {
									description: "SyncWindow contains the kind, time, duration and attributes that are used to assign the syncWindows to apps"

									properties: {
										applications: {
											description: "Applications contains a list of applications that the window will apply to"

											items: type: "string"
											type: "array"
										}
										clusters: {
											description: "Clusters contains a list of clusters that the window will apply to"

											items: type: "string"
											type: "array"
										}
										duration: {
											description: "Duration is the amount of time the sync window will be open"

											type: "string"
										}
										kind: {
											description: "Kind defines if the window allows or blocks syncs"
											type:        "string"
										}
										manualSync: {
											description: "ManualSync enables manual syncs when they would otherwise be blocked"

											type: "boolean"
										}
										namespaces: {
											description: "Namespaces contains a list of namespaces that the window will apply to"

											items: type: "string"
											type: "array"
										}
										schedule: {
											description: "Schedule is the time the window will begin, specified in cron format"

											type: "string"
										}
										timeZone: {
											description: "TimeZone of the sync that will be applied to the schedule"

											type: "string"
										}
									}
									type: "object"
								}
								type: "array"
							}
						}
						type: "object"
					}
					status: {
						description: "AppProjectStatus contains status information for AppProject CRs"

						properties: jwtTokensByRole: {
							additionalProperties: {
								description: "JWTTokens represents a list of JWT tokens"
								properties: items: {
									items: {
										description: "JWTToken holds the issuedAt and expiresAt values of a token"

										properties: {
											exp: {
												format: "int64"
												type:   "integer"
											}
											iat: {
												format: "int64"
												type:   "integer"
											}
											id: type: "string"
										}
										required: ["iat"]
										type: "object"
									}
									type: "array"
								}
								type: "object"
							}
							description: "JWTTokensByRole contains a list of JWT tokens issued for a given role"

							type: "object"
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-application-controller": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-application-controller"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "applicationset-controller"
			"app.kubernetes.io/name":      "argocd-applicationset-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "dex-server"
			"app.kubernetes.io/name":      "argocd-dex-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-dex-server"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-redis": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "redis"
			"app.kubernetes.io/name":      "argocd-redis"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-redis"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-repo-server": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "repo-server"
			"app.kubernetes.io/name":      "argocd-repo-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-repo-server"
		namespace: "argocd"
	}
}
res: serviceaccount: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server"
		namespace: "argocd"
	}
}
res: role: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-application-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-application-controller"
		namespace: "argocd"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"secrets",
			"configmaps",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["argoproj.io"]
		resources: [
			"applications",
			"appprojects",
		]
		verbs: [
			"create",
			"get",
			"list",
			"watch",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: [
			"create",
			"list",
		]
	}]
}
res: role: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "applicationset-controller"
			"app.kubernetes.io/name":      "argocd-applicationset-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}
	rules: [{
		apiGroups: ["argoproj.io"]
		resources: [
			"applications",
			"applicationsets",
			"applicationsets/finalizers",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"patch",
			"update",
			"watch",
		]
	}, {
		apiGroups: ["argoproj.io"]
		resources: ["appprojects"]
		verbs: ["get"]
	}, {
		apiGroups: ["argoproj.io"]
		resources: ["applicationsets/status"]
		verbs: [
			"get",
			"patch",
			"update",
		]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: [
			"create",
			"get",
			"list",
			"patch",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"secrets",
			"configmaps",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"apps",
			"extensions",
		]
		resources: ["deployments"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: role: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "dex-server"
			"app.kubernetes.io/name":      "argocd-dex-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-dex-server"
		namespace: "argocd"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"secrets",
			"configmaps",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: role: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller"
		namespace: "argocd"
	}
	rules: [{
		apiGroups: ["argoproj.io"]
		resources: [
			"applications",
			"appprojects",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"update",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"configmaps",
			"secrets",
		]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resourceNames: ["argocd-notifications-cm"]
		resources: ["configmaps"]
		verbs: ["get"]
	}, {
		apiGroups: [""]
		resourceNames: ["argocd-notifications-secret"]
		resources: ["secrets"]
		verbs: ["get"]
	}]
}
res: role: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server"
		namespace: "argocd"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"secrets",
			"configmaps",
		]
		verbs: [
			"create",
			"get",
			"list",
			"watch",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: ["argoproj.io"]
		resources: [
			"applications",
			"appprojects",
			"applicationsets",
		]
		verbs: [
			"create",
			"get",
			"list",
			"watch",
			"update",
			"delete",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: [
			"create",
			"list",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "argocd-application-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name: "argocd-application-controller"
	}
	rules: [{
		apiGroups: ["*"]
		resources: ["*"]
		verbs: ["*"]
	}, {
		nonResourceURLs: ["*"]
		verbs: ["*"]
	}]
}
res: clusterrole: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "argocd-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name: "argocd-server"
	}
	rules: [{
		apiGroups: ["*"]
		resources: ["*"]
		verbs: [
			"delete",
			"get",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: ["list"]
	}, {
		apiGroups: [""]
		resources: [
			"pods",
			"pods/log",
		]
		verbs: ["get"]
	}, {
		apiGroups: ["argoproj.io"]
		resources: [
			"applications",
			"applicationsets",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["batch"]
		resources: ["jobs"]
		verbs: ["create"]
	}, {
		apiGroups: ["argoproj.io"]
		resources: ["workflows"]
		verbs: ["create"]
	}]
}
res: rolebinding: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-application-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-application-controller"
		namespace: "argocd"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "argocd-application-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-application-controller"
		namespace: "argocd"
	}]
}
res: rolebinding: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "applicationset-controller"
			"app.kubernetes.io/name":      "argocd-applicationset-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "argocd-applicationset-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}]
}
res: rolebinding: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "dex-server"
			"app.kubernetes.io/name":      "argocd-dex-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-dex-server"
		namespace: "argocd"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "argocd-dex-server"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-dex-server"
		namespace: "argocd"
	}]
}
res: rolebinding: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller"
		namespace: "argocd"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "argocd-notifications-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-notifications-controller"
		namespace: "argocd"
	}]
}
res: rolebinding: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server"
		namespace: "argocd"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "argocd-server"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-server"
		namespace: "argocd"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "argocd-application-controller": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name: "argocd-application-controller"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "argocd-application-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-application-controller"
		namespace: "argocd"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district0-cluster-argo-cd": cluster: "argocd-server": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name: "argocd-server"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "argocd-server"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "argocd-server"
		namespace: "argocd"
	}]
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-cm": {
	apiVersion: "v1"
	data: {
		"application.resourceTrackingMethod": "annotation"
		"kustomize.buildOptions":             "--enable-helm"
		"resource.customizations.health.argoproj.io_Application": """
			hs = {}
			hs.status = \"Progressing\"
			hs.message = \"\"
			if obj.status ~= nil then
			    if obj.status.health ~= nil then
			    hs.status = obj.status.health.status
			    if obj.status.health.message ~= nil then
			        hs.message = obj.status.health.message
			    end
			    end
			end
			return hs
			"""

		"resource.customizations.health.networking.k8s.io_Ingress": """
			hs = {}
			hs.status = \"Healthy\"
			return hs
			"""

		"resource.customizations.health.tf.isaaguilar.com_Terraform": """
			hs = {}
			hs.status = \"Progressing\"
			hs.message = \"\"
			if obj.status ~= nil then
			    if obj.status.phase ~= nil then
			          if obj.status.phase == \"completed\" then
			               hs.status = \"Healthy\"
			         end

			          if obj.status.stage ~= nil then
			            if obj.status.stage.reason ~= nil then
			                  hs.message = obj.status.stage.reason
			            end
			          end
			    end
			end
			return hs
			"""

		"resource.customizations.ignoreDifferences.admissionregistration.k8s.io_MutatingWebhookConfiguration": """
			jsonPointers:
			  - /webhooks/0/clientConfig/caBundle
			  - /webhooks/0/rules

			"""

		"resource.customizations.ignoreDifferences.admissionregistration.k8s.io_ValidatingWebhookConfiguration": """
			jsonPointers:
			  - /webhooks/0/rules

			"""

		"resource.customizations.ignoreDifferences.apps_Deployment": """
			jsonPointers:
			  - /spec/template/spec/tolerations

			"""

		"resource.customizations.ignoreDifferences.kyverno.io_ClusterPolicy": """
			jqPathExpressions:
			  - .spec.rules[] | select(.name|test(\"autogen-.\"))

			"""
	}

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-cmd-params-cm": {
	apiVersion: "v1"
	data: "server.insecure": "true"
	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-cmd-params-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-cmd-params-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-gpg-keys-cm": {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-gpg-keys-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-gpg-keys-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-cm": {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-rbac-cm": {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-rbac-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-rbac-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-ssh-known-hosts-cm": {
	apiVersion: "v1"
	data: ssh_known_hosts: """
		# This file was automatically generated by hack/update-ssh-known-hosts.sh. DO NOT EDIT
		[ssh.github.com]:443 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
		[ssh.github.com]:443 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
		[ssh.github.com]:443 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
		bitbucket.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPIQmuzMBuKdWeF4+a2sjSSpBK0iqitSQ+5BM9KhpexuGt20JpTVM7u5BDZngncgrqDMbWdxMWWOGtZ9UgbqgZE=
		bitbucket.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIazEu89wgQZ4bqs3d63QSMzYVa0MuJ2e2gKTKqu+UUO
		bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQeJzhupRu0u0cdegZIa8e86EG2qOCsIsD1Xw0xSeiPDlCr7kq97NLmMbpKTX6Esc30NuoqEEHCuc7yWtwp8dI76EEEB1VqY9QJq6vk+aySyboD5QF61I/1WeTwu+deCbgKMGbUijeXhtfbxSxm6JwGrXrhBdofTsbKRUsrN1WoNgUa8uqN1Vx6WAJw1JHPhglEGGHea6QICwJOAr/6mrui/oB7pkaWKHj3z7d1IC4KWLtY47elvjbaTlkN04Kc/5LFEirorGYVbt15kAUlqGM65pk6ZBxtaO3+30LVlORZkxOh+LKL/BvbZ/iRNhItLqNyieoQj/uh/7Iv4uyH/cV/0b4WDSd3DptigWq84lJubb9t/DnZlrJazxyDCulTmKdOR7vs9gMTo+uoIrPSb8ScTtvw65+odKAlBj59dhnVp9zd7QUojOpXlL62Aw56U4oO+FALuevvMjiWeavKhJqlR7i5n9srYcrNV7ttmDw7kf/97P5zauIhxcjX+xHv4M=
		github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
		github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
		github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
		gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
		gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
		gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
		ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
		vs-ssh.visualstudio.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H

		"""

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-ssh-known-hosts-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-ssh-known-hosts-cm"
		namespace: "argocd"
	}
}
res: configmap: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-tls-certs-cm": {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-tls-certs-cm"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-tls-certs-cm"
		namespace: "argocd"
	}
}
res: secret: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-secret": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-secret"
		namespace: "argocd"
	}
	type: "Opaque"
}
res: secret: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-secret": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		labels: {
			"app.kubernetes.io/name":    "argocd-secret"
			"app.kubernetes.io/part-of": "argocd"
		}
		name:      "argocd-secret"
		namespace: "argocd"
	}
	type: "Opaque"
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "applicationset-controller"
			"app.kubernetes.io/name":      "argocd-applicationset-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "webhook"
			port:       7000
			protocol:   "TCP"
			targetPort: "webhook"
		}, {
			name:       "metrics"
			port:       8080
			protocol:   "TCP"
			targetPort: "metrics"
		}]
		selector: "app.kubernetes.io/name": "argocd-applicationset-controller"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "dex-server"
			"app.kubernetes.io/name":      "argocd-dex-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-dex-server"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			appProtocol: "TCP"
			name:        "http"
			port:        5556
			protocol:    "TCP"
			targetPort:  5556
		}, {
			name:       "grpc"
			port:       5557
			protocol:   "TCP"
			targetPort: 5557
		}, {
			name:       "metrics"
			port:       5558
			protocol:   "TCP"
			targetPort: 5558
		}]
		selector: "app.kubernetes.io/name": "argocd-dex-server"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-metrics": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "metrics"
			"app.kubernetes.io/name":      "argocd-metrics"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-metrics"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "metrics"
			port:       8082
			protocol:   "TCP"
			targetPort: 8082
		}]
		selector: "app.kubernetes.io/name": "argocd-application-controller"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller-metrics": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller-metrics"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller-metrics"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "metrics"
			port:       9001
			protocol:   "TCP"
			targetPort: 9001
		}]
		selector: "app.kubernetes.io/name": "argocd-notifications-controller"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-redis": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "redis"
			"app.kubernetes.io/name":      "argocd-redis"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-redis"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "tcp-redis"
			port:       6379
			targetPort: 6379
		}]
		selector: "app.kubernetes.io/name": "argocd-redis"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-repo-server": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "repo-server"
			"app.kubernetes.io/name":      "argocd-repo-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-repo-server"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "server"
			port:       8081
			protocol:   "TCP"
			targetPort: 8081
		}, {
			name:       "metrics"
			port:       8084
			protocol:   "TCP"
			targetPort: 8084
		}]
		selector: "app.kubernetes.io/name": "argocd-repo-server"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: "traefik.ingress.kubernetes.io/service.serverstransport": "traefik-insecure@kubernetescrd"
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			protocol:   "TCP"
			targetPort: 8080
		}, {
			name:       "https"
			port:       443
			protocol:   "TCP"
			targetPort: 8080
		}]
		selector: "app.kubernetes.io/name": "argocd-server"
	}
}
res: service: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server-metrics": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server-metrics"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server-metrics"
		namespace: "argocd"
	}
	spec: {
		ports: [{
			name:       "metrics"
			port:       8083
			protocol:   "TCP"
			targetPort: 8083
		}]
		selector: "app.kubernetes.io/name": "argocd-server"
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "applicationset-controller"
			"app.kubernetes.io/name":      "argocd-applicationset-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-applicationset-controller"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-applicationset-controller"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-applicationset-controller"
			spec: {
				containers: [{
					args: ["/usr/local/bin/argocd-applicationset-controller"]
					env: [{
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_GLOBAL_PRESERVED_ANNOTATIONS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.global.preserved.annotations"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_GLOBAL_PRESERVED_LABELS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.global.preserved.labels"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_LEADER_ELECTION"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.leader.election"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "repo.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_POLICY"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.policy"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_POLICY_OVERRIDE"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.policy.override"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_DEBUG"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.debug"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_LOGFORMAT"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.log.format"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_LOGLEVEL"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.log.level"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_DRY_RUN"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.dryrun"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_GIT_MODULES_ENABLED"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.git.submodule"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_PROGRESSIVE_SYNCS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.progressive.syncs"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_NEW_GIT_FILE_GLOBBING"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.new.git.file.globbing"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_PLAINTEXT"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.repo.server.plaintext"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_STRICT_TLS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.repo.server.strict.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_TIMEOUT_SECONDS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.repo.server.timeout.seconds"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_CONCURRENT_RECONCILIATIONS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.concurrent.reconciliations.max"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_NAMESPACES"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.namespaces"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_SCM_ROOT_CA_PATH"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.scm.root.ca.path"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ALLOWED_SCM_PROVIDERS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.allowed.scm.providers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_SCM_PROVIDERS"
						valueFrom: configMapKeyRef: {
							key:      "applicationsetcontroller.enable.scm.providers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					name:            "argocd-applicationset-controller"
					ports: [{
						containerPort: 7000
						name:          "webhook"
					}, {
						containerPort: 8080
						name:          "metrics"
					}]
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/app/config/ssh"
						name:      "ssh-known-hosts"
					}, {
						mountPath: "/app/config/tls"
						name:      "tls-certs"
					}, {
						mountPath: "/app/config/gpg/source"
						name:      "gpg-keys"
					}, {
						mountPath: "/app/config/gpg/keys"
						name:      "gpg-keyring"
					}, {
						mountPath: "/tmp"
						name:      "tmp"
					}, {
						mountPath: "/app/config/reposerver/tls"
						name:      "argocd-repo-server-tls"
					}]
				}]
				serviceAccountName: "argocd-applicationset-controller"
				volumes: [{
					configMap: name: "argocd-ssh-known-hosts-cm"
					name: "ssh-known-hosts"
				}, {
					configMap: name: "argocd-tls-certs-cm"
					name: "tls-certs"
				}, {
					configMap: name: "argocd-gpg-keys-cm"
					name: "gpg-keys"
				}, {
					emptyDir: {}
					name: "gpg-keyring"
				}, {
					emptyDir: {}
					name: "tmp"
				}, {
					name: "argocd-repo-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-repo-server-tls"
					}
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "dex-server"
			"app.kubernetes.io/name":      "argocd-dex-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-dex-server"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-dex-server"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-dex-server"
			spec: {
				affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/part-of": "argocd"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 5
				}]
				containers: [{
					command: [
						"/shared/argocd-dex",
						"rundex",
					]
					env: [{
						name: "ARGOCD_DEX_SERVER_DISABLE_TLS"
						valueFrom: configMapKeyRef: {
							key:      "dexserver.disable.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}]
					image:           "ghcr.io/dexidp/dex:v2.37.0"
					imagePullPolicy: "Always"
					name:            "dex"
					ports: [{
						containerPort: 5556
					}, {
						containerPort: 5557
					}, {
						containerPort: 5558
					}]
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/shared"
						name:      "static-files"
					}, {
						mountPath: "/tmp"
						name:      "dexconfig"
					}, {
						mountPath: "/tls"
						name:      "argocd-dex-server-tls"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/cp",
						"-n",
						"/usr/local/bin/argocd",
						"/shared/argocd-dex",
					]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					name:            "copyutil"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/shared"
						name:      "static-files"
					}, {
						mountPath: "/tmp"
						name:      "dexconfig"
					}]
				}]
				serviceAccountName: "argocd-dex-server"
				volumes: [{
					emptyDir: {}
					name: "static-files"
				}, {
					emptyDir: {}
					name: "dexconfig"
				}, {
					name: "argocd-dex-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-dex-server-tls"
					}
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-notifications-controller"
		strategy: type: "Recreate"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-notifications-controller"
			spec: {
				containers: [{
					args: ["/usr/local/bin/argocd-notifications"]
					env: [{
						name: "ARGOCD_NOTIFICATIONS_CONTROLLER_LOGFORMAT"
						valueFrom: configMapKeyRef: {
							key:      "notificationscontroller.log.format"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_NOTIFICATIONS_CONTROLLER_LOGLEVEL"
						valueFrom: configMapKeyRef: {
							key:      "notificationscontroller.log.level"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_NAMESPACES"
						valueFrom: configMapKeyRef: {
							key:      "application.namespaces"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_NOTIFICATION_CONTROLLER_SELF_SERVICE_NOTIFICATION_ENABLED"
						valueFrom: configMapKeyRef: {
							key:      "notificationscontroller.selfservice.enabled"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					livenessProbe: tcpSocket: port: 9001
					name: "argocd-notifications-controller"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
					}
					volumeMounts: [{
						mountPath: "/app/config/tls"
						name:      "tls-certs"
					}, {
						mountPath: "/app/config/reposerver/tls"
						name:      "argocd-repo-server-tls"
					}]
					workingDir: "/app"
				}]
				securityContext: {
					runAsNonRoot: true
					seccompProfile: type: "RuntimeDefault"
				}
				serviceAccountName: "argocd-notifications-controller"
				volumes: [{
					configMap: name: "argocd-tls-certs-cm"
					name: "tls-certs"
				}, {
					name: "argocd-repo-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-repo-server-tls"
					}
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-redis": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "redis"
			"app.kubernetes.io/name":      "argocd-redis"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-redis"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-redis"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-redis"
			spec: {
				affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/name": "argocd-redis"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 100
				}, {
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/part-of": "argocd"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 5
				}]
				containers: [{
					args: [
						"--save",
						"",
						"--appendonly",
						"no",
					]
					image:           "redis:7.0.14-alpine"
					imagePullPolicy: "Always"
					name:            "redis"
					ports: [{
						containerPort: 6379
					}]
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
					}
				}]
				securityContext: {
					runAsNonRoot: true
					runAsUser:    999
					seccompProfile: type: "RuntimeDefault"
				}
				serviceAccountName: "argocd-redis"
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-repo-server": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "repo-server"
			"app.kubernetes.io/name":      "argocd-repo-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-repo-server"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-repo-server"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-repo-server"
			spec: {
				affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/name": "argocd-repo-server"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 100
				}, {
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/part-of": "argocd"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 5
				}]
				automountServiceAccountToken: false
				containers: [{
					args: ["/usr/local/bin/argocd-repo-server"]
					env: [{
						name: "ARGOCD_RECONCILIATION_TIMEOUT"
						valueFrom: configMapKeyRef: {
							key:      "timeout.reconciliation"
							name:     "argocd-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_LOGFORMAT"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.log.format"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_LOGLEVEL"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.log.level"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_PARALLELISM_LIMIT"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.parallelism.limit"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_LISTEN_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.listen.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_LISTEN_METRICS_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.metrics.listen.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_DISABLE_TLS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.disable.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_MIN_VERSION"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.tls.minversion"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_MAX_VERSION"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.tls.maxversion"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_CIPHERS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.tls.ciphers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.repo.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "redis.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_COMPRESSION"
						valueFrom: configMapKeyRef: {
							key:      "redis.compression"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDISDB"
						valueFrom: configMapKeyRef: {
							key:      "redis.db"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_DEFAULT_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.default.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_OTLP_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_OTLP_INSECURE"
						valueFrom: configMapKeyRef: {
							key:      "otlp.insecure"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_OTLP_HEADERS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.headers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_MAX_COMBINED_DIRECTORY_MANIFESTS_SIZE"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.max.combined.directory.manifests.size"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_PLUGIN_TAR_EXCLUSIONS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.plugin.tar.exclusions"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_ALLOW_OUT_OF_BOUNDS_SYMLINKS"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.allow.oob.symlinks"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_STREAMED_MANIFEST_MAX_TAR_SIZE"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.streamed.manifest.max.tar.size"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_STREAMED_MANIFEST_MAX_EXTRACTED_SIZE"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.streamed.manifest.max.extracted.size"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_HELM_MANIFEST_MAX_EXTRACTED_SIZE"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.helm.manifest.max.extracted.size"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_SERVER_DISABLE_HELM_MANIFEST_MAX_EXTRACTED_SIZE"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.disable.helm.manifest.max.extracted.size"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_GIT_MODULES_ENABLED"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.enable.git.submodule"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_GIT_LS_REMOTE_PARALLELISM_LIMIT"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.git.lsremote.parallelism.limit"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_GIT_REQUEST_TIMEOUT"
						valueFrom: configMapKeyRef: {
							key:      "reposerver.git.request.timeout"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name:  "HELM_CACHE_HOME"
						value: "/helm-working-dir"
					}, {
						name:  "HELM_CONFIG_HOME"
						value: "/helm-working-dir"
					}, {
						name:  "HELM_DATA_HOME"
						value: "/helm-working-dir"
					}]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					livenessProbe: {
						failureThreshold: 3
						httpGet: {
							path: "/healthz?full=true"
							port: 8084
						}
						initialDelaySeconds: 30
						periodSeconds:       30
						timeoutSeconds:      5
					}
					name: "argocd-repo-server"
					ports: [{
						containerPort: 8081
					}, {
						containerPort: 8084
					}]
					readinessProbe: {
						httpGet: {
							path: "/healthz"
							port: 8084
						}
						initialDelaySeconds: 5
						periodSeconds:       10
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/app/config/ssh"
						name:      "ssh-known-hosts"
					}, {
						mountPath: "/app/config/tls"
						name:      "tls-certs"
					}, {
						mountPath: "/app/config/gpg/source"
						name:      "gpg-keys"
					}, {
						mountPath: "/app/config/gpg/keys"
						name:      "gpg-keyring"
					}, {
						mountPath: "/app/config/reposerver/tls"
						name:      "argocd-repo-server-tls"
					}, {
						mountPath: "/tmp"
						name:      "tmp"
					}, {
						mountPath: "/helm-working-dir"
						name:      "helm-working-dir"
					}, {
						mountPath: "/home/argocd/cmp-server/plugins"
						name:      "plugins"
					}]
				}]
				initContainers: [{
					command: [
						"/bin/cp",
						"-n",
						"/usr/local/bin/argocd",
						"/var/run/argocd/argocd-cmp-server",
					]
					image: "quay.io/argoproj/argocd:v2.10.0-rc1"
					name:  "copyutil"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/var/run/argocd"
						name:      "var-files"
					}]
				}]
				serviceAccountName: "argocd-repo-server"
				volumes: [{
					configMap: name: "argocd-ssh-known-hosts-cm"
					name: "ssh-known-hosts"
				}, {
					configMap: name: "argocd-tls-certs-cm"
					name: "tls-certs"
				}, {
					configMap: name: "argocd-gpg-keys-cm"
					name: "gpg-keys"
				}, {
					emptyDir: {}
					name: "gpg-keyring"
				}, {
					emptyDir: {}
					name: "tmp"
				}, {
					emptyDir: {}
					name: "helm-working-dir"
				}, {
					name: "argocd-repo-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-repo-server-tls"
					}
				}, {
					emptyDir: {}
					name: "var-files"
				}, {
					emptyDir: {}
					name: "plugins"
				}]
			}
		}
	}
}
res: deployment: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "server"
			"app.kubernetes.io/name":      "argocd-server"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-server"
		namespace: "argocd"
	}
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": "argocd-server"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-server"
			spec: {
				affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/name": "argocd-server"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 100
				}, {
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/part-of": "argocd"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 5
				}]
				containers: [{
					args: ["/usr/local/bin/argocd-server"]
					env: [{
						name: "ARGOCD_SERVER_INSECURE"
						valueFrom: configMapKeyRef: {
							key:      "server.insecure"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_BASEHREF"
						valueFrom: configMapKeyRef: {
							key:      "server.basehref"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_ROOTPATH"
						valueFrom: configMapKeyRef: {
							key:      "server.rootpath"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_LOGFORMAT"
						valueFrom: configMapKeyRef: {
							key:      "server.log.format"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_LOG_LEVEL"
						valueFrom: configMapKeyRef: {
							key:      "server.log.level"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_REPO_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "repo.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_DEX_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "server.dex.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_DISABLE_AUTH"
						valueFrom: configMapKeyRef: {
							key:      "server.disable.auth"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_ENABLE_GZIP"
						valueFrom: configMapKeyRef: {
							key:      "server.enable.gzip"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_REPO_SERVER_TIMEOUT_SECONDS"
						valueFrom: configMapKeyRef: {
							key:      "server.repo.server.timeout.seconds"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_X_FRAME_OPTIONS"
						valueFrom: configMapKeyRef: {
							key:      "server.x.frame.options"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_CONTENT_SECURITY_POLICY"
						valueFrom: configMapKeyRef: {
							key:      "server.content.security.policy"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_REPO_SERVER_PLAINTEXT"
						valueFrom: configMapKeyRef: {
							key:      "server.repo.server.plaintext"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_REPO_SERVER_STRICT_TLS"
						valueFrom: configMapKeyRef: {
							key:      "server.repo.server.strict.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_DEX_SERVER_PLAINTEXT"
						valueFrom: configMapKeyRef: {
							key:      "server.dex.server.plaintext"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_DEX_SERVER_STRICT_TLS"
						valueFrom: configMapKeyRef: {
							key:      "server.dex.server.strict.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_MIN_VERSION"
						valueFrom: configMapKeyRef: {
							key:      "server.tls.minversion"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_MAX_VERSION"
						valueFrom: configMapKeyRef: {
							key:      "server.tls.maxversion"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_TLS_CIPHERS"
						valueFrom: configMapKeyRef: {
							key:      "server.tls.ciphers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_CONNECTION_STATUS_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "server.connection.status.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_OIDC_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "server.oidc.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_LOGIN_ATTEMPTS_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "server.login.attempts.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_STATIC_ASSETS"
						valueFrom: configMapKeyRef: {
							key:      "server.staticassets"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APP_STATE_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "server.app.state.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "redis.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_COMPRESSION"
						valueFrom: configMapKeyRef: {
							key:      "redis.compression"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDISDB"
						valueFrom: configMapKeyRef: {
							key:      "redis.db"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_DEFAULT_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "server.default.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_MAX_COOKIE_NUMBER"
						valueFrom: configMapKeyRef: {
							key:      "server.http.cookie.maxnumber"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_LISTEN_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "server.listen.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_METRICS_LISTEN_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "server.metrics.listen.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_OTLP_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_OTLP_INSECURE"
						valueFrom: configMapKeyRef: {
							key:      "otlp.insecure"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_OTLP_HEADERS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.headers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_NAMESPACES"
						valueFrom: configMapKeyRef: {
							key:      "application.namespaces"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_SERVER_ENABLE_PROXY_EXTENSION"
						valueFrom: configMapKeyRef: {
							key:      "server.enable.proxy.extension"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_K8SCLIENT_RETRY_MAX"
						valueFrom: configMapKeyRef: {
							key:      "server.k8sclient.retry.max"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_K8SCLIENT_RETRY_BASE_BACKOFF"
						valueFrom: configMapKeyRef: {
							key:      "server.k8sclient.retry.base.backoff"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					livenessProbe: {
						httpGet: {
							path: "/healthz?full=true"
							port: 8080
						}
						initialDelaySeconds: 3
						periodSeconds:       30
						timeoutSeconds:      5
					}
					name: "argocd-server"
					ports: [{
						containerPort: 8080
					}, {
						containerPort: 8083
					}]
					readinessProbe: {
						httpGet: {
							path: "/healthz"
							port: 8080
						}
						initialDelaySeconds: 3
						periodSeconds:       30
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/app/config/ssh"
						name:      "ssh-known-hosts"
					}, {
						mountPath: "/app/config/tls"
						name:      "tls-certs"
					}, {
						mountPath: "/app/config/server/tls"
						name:      "argocd-repo-server-tls"
					}, {
						mountPath: "/app/config/dex/tls"
						name:      "argocd-dex-server-tls"
					}, {
						mountPath: "/home/argocd"
						name:      "plugins-home"
					}, {
						mountPath: "/tmp"
						name:      "tmp"
					}]
				}]
				serviceAccountName: "argocd-server"
				volumes: [{
					emptyDir: {}
					name: "plugins-home"
				}, {
					emptyDir: {}
					name: "tmp"
				}, {
					configMap: name: "argocd-ssh-known-hosts-cm"
					name: "ssh-known-hosts"
				}, {
					configMap: name: "argocd-tls-certs-cm"
					name: "tls-certs"
				}, {
					name: "argocd-repo-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-repo-server-tls"
					}
				}, {
					name: "argocd-dex-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-dex-server-tls"
					}
				}]
			}
		}
	}
}
res: statefulset: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-application-controller": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "application-controller"
			"app.kubernetes.io/name":      "argocd-application-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-application-controller"
		namespace: "argocd"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "app.kubernetes.io/name": "argocd-application-controller"
		serviceName: "argocd-application-controller"
		template: {
			metadata: labels: "app.kubernetes.io/name": "argocd-application-controller"
			spec: {
				affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/name": "argocd-application-controller"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 100
				}, {
					podAffinityTerm: {
						labelSelector: matchLabels: "app.kubernetes.io/part-of": "argocd"
						topologyKey: "kubernetes.io/hostname"
					}
					weight: 5
				}]
				containers: [{
					args: ["/usr/local/bin/argocd-application-controller"]
					env: [{
						name:  "ARGOCD_CONTROLLER_REPLICAS"
						value: "1"
					}, {
						name: "ARGOCD_RECONCILIATION_TIMEOUT"
						valueFrom: configMapKeyRef: {
							key:      "timeout.reconciliation"
							name:     "argocd-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_HARD_RECONCILIATION_TIMEOUT"
						valueFrom: configMapKeyRef: {
							key:      "timeout.hard.reconciliation"
							name:     "argocd-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_REPO_ERROR_GRACE_PERIOD_SECONDS"
						valueFrom: configMapKeyRef: {
							key:      "controller.repo.error.grace.period.seconds"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "repo.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_TIMEOUT_SECONDS"
						valueFrom: configMapKeyRef: {
							key:      "controller.repo.server.timeout.seconds"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_STATUS_PROCESSORS"
						valueFrom: configMapKeyRef: {
							key:      "controller.status.processors"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_OPERATION_PROCESSORS"
						valueFrom: configMapKeyRef: {
							key:      "controller.operation.processors"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_LOGFORMAT"
						valueFrom: configMapKeyRef: {
							key:      "controller.log.format"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_LOGLEVEL"
						valueFrom: configMapKeyRef: {
							key:      "controller.log.level"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_METRICS_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "controller.metrics.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_TIMEOUT_SECONDS"
						valueFrom: configMapKeyRef: {
							key:      "controller.self.heal.timeout.seconds"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_PLAINTEXT"
						valueFrom: configMapKeyRef: {
							key:      "controller.repo.server.plaintext"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_STRICT_TLS"
						valueFrom: configMapKeyRef: {
							key:      "controller.repo.server.strict.tls"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_PERSIST_RESOURCE_HEALTH"
						valueFrom: configMapKeyRef: {
							key:      "controller.resource.health.persist"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APP_STATE_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "controller.app.state.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_SERVER"
						valueFrom: configMapKeyRef: {
							key:      "redis.server"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDIS_COMPRESSION"
						valueFrom: configMapKeyRef: {
							key:      "redis.compression"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "REDISDB"
						valueFrom: configMapKeyRef: {
							key:      "redis.db"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_DEFAULT_CACHE_EXPIRATION"
						valueFrom: configMapKeyRef: {
							key:      "controller.default.cache.expiration"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_OTLP_ADDRESS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.address"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_OTLP_INSECURE"
						valueFrom: configMapKeyRef: {
							key:      "otlp.insecure"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_OTLP_HEADERS"
						valueFrom: configMapKeyRef: {
							key:      "otlp.headers"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_NAMESPACES"
						valueFrom: configMapKeyRef: {
							key:      "application.namespaces"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_CONTROLLER_SHARDING_ALGORITHM"
						valueFrom: configMapKeyRef: {
							key:      "controller.sharding.algorithm"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_KUBECTL_PARALLELISM_LIMIT"
						valueFrom: configMapKeyRef: {
							key:      "controller.kubectl.parallelism.limit"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_K8SCLIENT_RETRY_MAX"
						valueFrom: configMapKeyRef: {
							key:      "controller.k8sclient.retry.max"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_K8SCLIENT_RETRY_BASE_BACKOFF"
						valueFrom: configMapKeyRef: {
							key:      "controller.k8sclient.retry.base.backoff"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}, {
						name: "ARGOCD_APPLICATION_CONTROLLER_SERVER_SIDE_DIFF"
						valueFrom: configMapKeyRef: {
							key:      "controller.diff.server.side"
							name:     "argocd-cmd-params-cm"
							optional: true
						}
					}]
					image:           "quay.io/argoproj/argocd:v2.10.0-rc1"
					imagePullPolicy: "Always"
					name:            "argocd-application-controller"
					ports: [{
						containerPort: 8082
					}]
					readinessProbe: {
						httpGet: {
							path: "/healthz"
							port: 8082
						}
						initialDelaySeconds: 5
						periodSeconds:       10
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/app/config/controller/tls"
						name:      "argocd-repo-server-tls"
					}, {
						mountPath: "/home/argocd"
						name:      "argocd-home"
					}]
					workingDir: "/home/argocd"
				}]
				serviceAccountName: "argocd-application-controller"
				volumes: [{
					emptyDir: {}
					name: "argocd-home"
				}, {
					name: "argocd-repo-server-tls"
					secret: {
						items: [{
							key:  "tls.crt"
							path: "tls.crt"
						}, {
							key:  "tls.key"
							path: "tls.key"
						}, {
							key:  "ca.crt"
							path: "ca.crt"
						}]
						optional:   true
						secretName: "argocd-repo-server-tls"
					}
				}]
			}
		}
	}
}
res: ingress: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argo-cd": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			"traefik.ingress.kubernetes.io/router.tls":         "true"
		}
		name:      "argo-cd"
		namespace: "argocd"
	}
	spec: {
		ingressClassName: "traefik"
		rules: [{
			host: "argocd-district0.district.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "argocd-server"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-application-controller-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-application-controller-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{
			from: [{
				namespaceSelector: {}}]
			ports: [{
				port: 8082
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-application-controller"
		policyTypes: ["Ingress"]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-applicationset-controller-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-applicationset-controller-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{
			from: [{
				namespaceSelector: {}}]
			ports: [{
				port:     7000
				protocol: "TCP"
			}, {
				port:     8080
				protocol: "TCP"
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-applicationset-controller"
		policyTypes: ["Ingress"]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-dex-server-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-dex-server-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{
			from: [{
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-server"
			}]
			ports: [{
				port:     5556
				protocol: "TCP"
			}, {
				port:     5557
				protocol: "TCP"
			}]
		}, {
			from: [{
				namespaceSelector: {}}]
			ports: [{
				port:     5558
				protocol: "TCP"
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-dex-server"
		policyTypes: ["Ingress"]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-notifications-controller-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		labels: {
			"app.kubernetes.io/component": "notifications-controller"
			"app.kubernetes.io/name":      "argocd-notifications-controller"
			"app.kubernetes.io/part-of":   "argocd"
		}
		name:      "argocd-notifications-controller-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{
			from: [{
				namespaceSelector: {}}]
			ports: [{
				port:     9001
				protocol: "TCP"
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-notifications-controller"
		policyTypes: ["Ingress"]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-redis-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-redis-network-policy"
		namespace: "argocd"
	}
	spec: {
		egress: [{
			ports: [{
				port:     53
				protocol: "UDP"
			}, {
				port:     53
				protocol: "TCP"
			}]
		}]
		ingress: [{
			from: [{
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-server"
			}, {
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-repo-server"
			}, {
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-application-controller"
			}]
			ports: [{
				port:     6379
				protocol: "TCP"
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-redis"
		policyTypes: [
			"Ingress",
			"Egress",
		]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-repo-server-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-repo-server-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{
			from: [{
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-server"
			}, {
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-application-controller"
			}, {
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-notifications-controller"
			}, {
				podSelector: matchLabels: "app.kubernetes.io/name": "argocd-applicationset-controller"
			}]
			ports: [{
				port:     8081
				protocol: "TCP"
			}]
		}, {
			from: [{
				namespaceSelector: {}}]
			ports: [{
				port: 8084
			}]
		}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-repo-server"
		policyTypes: ["Ingress"]
	}
}
res: networkpolicy: "coder-amanibhavam-district0-cluster-argo-cd": argocd: "argocd-server-network-policy": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: {
		name:      "argocd-server-network-policy"
		namespace: "argocd"
	}
	spec: {
		ingress: [{}]
		podSelector: matchLabels: "app.kubernetes.io/name": "argocd-server"
		policyTypes: ["Ingress"]
	}
}
