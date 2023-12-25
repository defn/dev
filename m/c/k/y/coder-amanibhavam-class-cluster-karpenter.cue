package y

res: namespace: "coder-amanibhavam-class-cluster-karpenter": cluster: karpenter: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "karpenter"
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "awsnodetemplates.karpenter.k8s.aws": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "awsnodetemplates.karpenter.k8s.aws"
	}
	spec: {
		group: "karpenter.k8s.aws"
		names: {
			categories: ["karpenter"]
			kind:     "AWSNodeTemplate"
			listKind: "AWSNodeTemplateList"
			plural:   "awsnodetemplates"
			singular: "awsnodetemplate"
		}
		scope: "Cluster"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "AWSNodeTemplate is the Schema for the AWSNodeTemplate API"
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
						description: "AWSNodeTemplateSpec is the top level specification for the AWS Karpenter Provider. This will contain configuration necessary to launch instances in AWS."

						properties: {
							amiFamily: {
								description: "AMIFamily is the AMI family that instances use."
								type:        "string"
							}
							amiSelector: {
								additionalProperties: type: "string"
								description: "AMISelector discovers AMIs to be used by Amazon EC2 tags."
								type:        "object"
							}
							apiVersion: {
								description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

								type: "string"
							}
							blockDeviceMappings: {
								description: "BlockDeviceMappings to be applied to provisioned nodes."
								items: {
									properties: {
										deviceName: {
											description: "The device name (for example, /dev/sdh or xvdh)."
											type:        "string"
										}
										ebs: {
											description: "EBS contains parameters used to automatically set up EBS volumes when an instance is launched."

											properties: {
												deleteOnTermination: {
													description: "DeleteOnTermination indicates whether the EBS volume is deleted on instance termination."

													type: "boolean"
												}
												encrypted: {
													description: "Encrypted indicates whether the EBS volume is encrypted. Encrypted volumes can only be attached to instances that support Amazon EBS encryption. If you are creating a volume from a snapshot, you can't specify an encryption value."

													type: "boolean"
												}
												iops: {
													description: """
		IOPS is the number of I/O operations per second (IOPS). For gp3, io1, and io2 volumes, this represents the number of IOPS that are provisioned for the volume. For gp2 volumes, this represents the baseline performance of the volume and the rate at which the volume accumulates I/O credits for bursting. 
		 The following are the supported values for each volume type: 
		 * gp3: 3,000-16,000 IOPS 
		 * io1: 100-64,000 IOPS 
		 * io2: 100-64,000 IOPS 
		 For io1 and io2 volumes, we guarantee 64,000 IOPS only for Instances built on the Nitro System (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#ec2-nitro-instances). Other instance families guarantee performance up to 32,000 IOPS. 
		 This parameter is supported for io1, io2, and gp3 volumes only. This parameter is not supported for gp2, st1, sc1, or standard volumes.
		"""

													format: "int64"
													type:   "integer"
												}
												kmsKeyID: {
													description: "KMSKeyID (ARN) of the symmetric Key Management Service (KMS) CMK used for encryption."

													type: "string"
												}
												snapshotID: {
													description: "SnapshotID is the ID of an EBS snapshot"
													type:        "string"
												}
												throughput: {
													description: "Throughput to provision for a gp3 volume, with a maximum of 1,000 MiB/s. Valid Range: Minimum value of 125. Maximum value of 1000."

													format: "int64"
													type:   "integer"
												}
												volumeSize: {
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													description: """
		VolumeSize in GiBs. You must specify either a snapshot ID or a volume size. The following are the supported volumes sizes for each volume type: 
		 * gp2 and gp3: 1-16,384 
		 * io1 and io2: 4-16,384 
		 * st1 and sc1: 125-16,384 
		 * standard: 1-1,024
		"""

													pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
													"x-kubernetes-int-or-string": true
												}
												volumeType: {
													description: "VolumeType of the block device. For more information, see Amazon EBS volume types (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html) in the Amazon Elastic Compute Cloud User Guide."

													type: "string"
												}
											}
											type: "object"
										}
									}
									type: "object"
								}
								type: "array"
							}
							context: {
								description: "Context is a Reserved field in EC2 APIs https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateFleet.html"
								type:        "string"
							}
							detailedMonitoring: {
								description: "DetailedMonitoring controls if detailed monitoring is enabled for instances that are launched"

								type: "boolean"
							}
							instanceProfile: {
								description: "InstanceProfile is the AWS identity that instances use."
								type:        "string"
							}
							kind: {
								description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

								type: "string"
							}
							launchTemplate: {
								description: "LaunchTemplateName for the node. If not specified, a launch template will be generated. NOTE: This field is for specifying a custom launch template and is exposed in the Spec as `launchTemplate` for backwards compatibility."

								type: "string"
							}
							metadataOptions: {
								description: """
		MetadataOptions for the generated launch template of provisioned nodes. 
		 This specifies the exposure of the Instance Metadata Service to provisioned EC2 nodes. For more information, see Instance Metadata and User Data (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) in the Amazon Elastic Compute Cloud User Guide. 
		 Refer to recommended, security best practices (https://aws.github.io/aws-eks-best-practices/security/docs/iam/#restrict-access-to-the-instance-profile-assigned-to-the-worker-node) for limiting exposure of Instance Metadata and User Data to pods. If omitted, defaults to httpEndpoint enabled, with httpProtocolIPv6 disabled, with httpPutResponseLimit of 2, and with httpTokens required.
		"""

								properties: {
									httpEndpoint: {
										description: """
		HTTPEndpoint enables or disables the HTTP metadata endpoint on provisioned nodes. If metadata options is non-nil, but this parameter is not specified, the default state is \"enabled\". 
		 If you specify a value of \"disabled\", instance metadata will not be accessible on the node.
		"""

										type: "string"
									}
									httpProtocolIPv6: {
										description: "HTTPProtocolIPv6 enables or disables the IPv6 endpoint for the instance metadata service on provisioned nodes. If metadata options is non-nil, but this parameter is not specified, the default state is \"disabled\"."

										type: "string"
									}
									httpPutResponseHopLimit: {
										description: "HTTPPutResponseHopLimit is the desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. Possible values are integers from 1 to 64. If metadata options is non-nil, but this parameter is not specified, the default value is 1."

										format: "int64"
										type:   "integer"
									}
									httpTokens: {
										description: """
		HTTPTokens determines the state of token usage for instance metadata requests. If metadata options is non-nil, but this parameter is not specified, the default state is \"optional\". 
		 If the state is optional, one can choose to retrieve instance metadata with or without a signed token header on the request. If one retrieves the IAM role credentials without a token, the version 1.0 role credentials are returned. If one retrieves the IAM role credentials using a valid signed token, the version 2.0 role credentials are returned. 
		 If the state is \"required\", one must send a signed token header with any instance metadata retrieval requests. In this state, retrieving the IAM role credentials always returns the version 2.0 credentials; the version 1.0 credentials are not available.
		"""

										type: "string"
									}
								}
								type: "object"
							}
							securityGroupSelector: {
								additionalProperties: type: "string"
								description: "SecurityGroups specify the names of the security groups."
								type:        "object"
							}
							subnetSelector: {
								additionalProperties: type: "string"
								description: "SubnetSelector discovers subnets by tags. A value of \"\" is a wildcard."

								type: "object"
							}
							tags: {
								additionalProperties: type: "string"
								description: "Tags to be applied on ec2 resources like instances and launch templates."

								type: "object"
							}
							userData: {
								description: "UserData to be applied to the provisioned nodes. It must be in the appropriate format based on the AMIFamily in use. Karpenter will merge certain fields into this UserData to ensure nodes are being provisioned with the correct configuration."

								type: "string"
							}
						}
						type: "object"
					}
					status: {
						description: "AWSNodeTemplateStatus contains the resolved state of the AWSNodeTemplate"

						properties: {
							amis: {
								description: "AMI contains the current AMI values that are available to the cluster under the AMI selectors."

								items: {
									description: "AMI contains resolved AMI selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the AMI"
											type:        "string"
										}
										name: {
											description: "Name of the AMI"
											type:        "string"
										}
										requirements: {
											description: "Requirements of the AMI to be utilized on an instance type"

											items: {
												description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

												properties: {
													key: {
														description: "The label key that the selector applies to."
														type:        "string"
													}
													operator: {
														description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

														type: "string"
													}
													values: {
														description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

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
									}
									required: [
										"id",
										"requirements",
									]
									type: "object"
								}
								type: "array"
							}
							securityGroups: {
								description: "SecurityGroups contains the current Security Groups values that are available to the cluster under the SecurityGroups selectors."

								items: {
									description: "SecurityGroup contains resolved SecurityGroup selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the security group"
											type:        "string"
										}
										name: {
											description: "Name of the security group"
											type:        "string"
										}
									}
									required: ["id"]
									type: "object"
								}
								type: "array"
							}
							subnets: {
								description: "Subnets contains the current Subnet values that are available to the cluster under the subnet selectors."

								items: {
									description: "Subnet contains resolved Subnet selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the subnet"
											type:        "string"
										}
										zone: {
											description: "The associated availability zone"
											type:        "string"
										}
									}
									required: [
										"id",
										"zone",
									]
									type: "object"
								}
								type: "array"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "ec2nodeclasses.karpenter.k8s.aws": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "ec2nodeclasses.karpenter.k8s.aws"
	}
	spec: {
		group: "karpenter.k8s.aws"
		names: {
			categories: ["karpenter"]
			kind:     "EC2NodeClass"
			listKind: "EC2NodeClassList"
			plural:   "ec2nodeclasses"
			shortNames: [
				"ec2nc",
				"ec2ncs",
			]
			singular: "ec2nodeclass"
		}
		scope: "Cluster"
		versions: [{
			name: "v1beta1"
			schema: openAPIV3Schema: {
				description: "EC2NodeClass is the Schema for the EC2NodeClass API"
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
						description: "EC2NodeClassSpec is the top level specification for the AWS Karpenter Provider. This will contain configuration necessary to launch instances in AWS."

						properties: {
							amiFamily: {
								description: "AMIFamily is the AMI family that instances use."
								enum: [
									"AL2",
									"Bottlerocket",
									"Ubuntu",
									"Custom",
									"Windows2019",
									"Windows2022",
								]
								type: "string"
							}
							amiSelectorTerms: {
								description: "AMISelectorTerms is a list of or ami selector terms. The terms are ORed."

								items: {
									description: "AMISelectorTerm defines selection logic for an ami used by Karpenter to launch nodes. If multiple fields are used for selection, the requirements are ANDed."

									properties: {
										id: {
											description: "ID is the ami id in EC2"
											pattern:     "ami-[0-9a-z]+"
											type:        "string"
										}
										name: {
											description: "Name is the ami name in EC2. This value is the name field, which is different from the name tag."

											type: "string"
										}
										owner: {
											description: "Owner is the owner for the ami. You can specify a combination of AWS account IDs, \"self\", \"amazon\", and \"aws-marketplace\""

											type: "string"
										}
										tags: {
											additionalProperties: type: "string"
											description: "Tags is a map of key/value tags used to select subnets Specifying '*' for a value selects all values for a given tag key."

											maxProperties: 20
											type:          "object"
											"x-kubernetes-validations": [{
												message: "empty tag keys or values aren't supported"
												rule:    "self.all(k, k != '' && self[k] != '')"
											}]
										}
									}
									type: "object"
								}
								maxItems: 30
								type:     "array"
								"x-kubernetes-validations": [{
									message: "expected at least one, got none, ['tags', 'id', 'name']"
									rule:    "self.all(x, has(x.tags) || has(x.id) || has(x.name))"
								}, {
									message: "'id' is mutually exclusive, cannot be set with a combination of other fields in amiSelectorTerms"

									rule: "!self.all(x, has(x.id) && (has(x.tags) || has(x.name) || has(x.owner)))"
								}]
							}

							blockDeviceMappings: {
								description: "BlockDeviceMappings to be applied to provisioned nodes."
								items: {
									properties: {
										deviceName: {
											description: "The device name (for example, /dev/sdh or xvdh)."
											type:        "string"
										}
										ebs: {
											description: "EBS contains parameters used to automatically set up EBS volumes when an instance is launched."

											properties: {
												deleteOnTermination: {
													description: "DeleteOnTermination indicates whether the EBS volume is deleted on instance termination."

													type: "boolean"
												}
												encrypted: {
													description: "Encrypted indicates whether the EBS volume is encrypted. Encrypted volumes can only be attached to instances that support Amazon EBS encryption. If you are creating a volume from a snapshot, you can't specify an encryption value."

													type: "boolean"
												}
												iops: {
													description: """
		IOPS is the number of I/O operations per second (IOPS). For gp3, io1, and io2 volumes, this represents the number of IOPS that are provisioned for the volume. For gp2 volumes, this represents the baseline performance of the volume and the rate at which the volume accumulates I/O credits for bursting. 
		 The following are the supported values for each volume type: 
		 * gp3: 3,000-16,000 IOPS 
		 * io1: 100-64,000 IOPS 
		 * io2: 100-64,000 IOPS 
		 For io1 and io2 volumes, we guarantee 64,000 IOPS only for Instances built on the Nitro System (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#ec2-nitro-instances). Other instance families guarantee performance up to 32,000 IOPS. 
		 This parameter is supported for io1, io2, and gp3 volumes only. This parameter is not supported for gp2, st1, sc1, or standard volumes.
		"""

													format: "int64"
													type:   "integer"
												}
												kmsKeyID: {
													description: "KMSKeyID (ARN) of the symmetric Key Management Service (KMS) CMK used for encryption."

													type: "string"
												}
												snapshotID: {
													description: "SnapshotID is the ID of an EBS snapshot"
													type:        "string"
												}
												throughput: {
													description: "Throughput to provision for a gp3 volume, with a maximum of 1,000 MiB/s. Valid Range: Minimum value of 125. Maximum value of 1000."

													format: "int64"
													type:   "integer"
												}
												volumeSize: {
													allOf: [{
														pattern: "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
													}, {
														pattern: "^((?:[1-9][0-9]{0,3}|[1-4][0-9]{4}|[5][0-8][0-9]{3}|59000)Gi|(?:[1-9][0-9]{0,3}|[1-5][0-9]{4}|[6][0-3][0-9]{3}|64000)G|([1-9]||[1-5][0-7]|58)Ti|([1-9]||[1-5][0-9]|6[0-3]|64)T)$"
													}]
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													description: """
		VolumeSize in `Gi`, `G`, `Ti`, or `T`. You must specify either a snapshot ID or a volume size. The following are the supported volumes sizes for each volume type: 
		 * gp2 and gp3: 1-16,384 
		 * io1 and io2: 4-16,384 
		 * st1 and sc1: 125-16,384 
		 * standard: 1-1,024
		"""

													"x-kubernetes-int-or-string": true
												}
												volumeType: {
													description: "VolumeType of the block device. For more information, see Amazon EBS volume types (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html) in the Amazon Elastic Compute Cloud User Guide."

													enum: [
														"standard",
														"io1",
														"io2",
														"gp2",
														"sc1",
														"st1",
														"gp3",
													]
													type: "string"
												}
											}
											type: "object"
											"x-kubernetes-validations": [{
												message: "snapshotID or volumeSize must be defined"
												rule:    "has(self.snapshotID) || has(self.volumeSize)"
											}]
										}
										rootVolume: {
											description: "RootVolume is a flag indicating if this device is mounted as kubelet root dir. You can configure at most one root volume in BlockDeviceMappings."

											type: "boolean"
										}
									}
									type: "object"
								}
								maxItems: 50
								type:     "array"
								"x-kubernetes-validations": [{
									message: "must have only one blockDeviceMappings with rootVolume"
									rule:    "self.filter(x, has(x.rootVolume)?x.rootVolume==true:false).size() <= 1"
								}]
							}

							context: {
								description: "Context is a Reserved field in EC2 APIs https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateFleet.html"
								type:        "string"
							}
							detailedMonitoring: {
								description: "DetailedMonitoring controls if detailed monitoring is enabled for instances that are launched"

								type: "boolean"
							}
							instanceProfile: {
								description: "InstanceProfile is the AWS entity that instances use. This field is mutually exclusive from role. The instance profile should already have a role assigned to it that Karpenter has PassRole permission on for instance launch using this instanceProfile to succeed."

								type: "string"
								"x-kubernetes-validations": [{
									message: "instanceProfile cannot be empty"
									rule:    "self != ''"
								}]
							}
							metadataOptions: {
								default: {
									httpEndpoint:            "enabled"
									httpProtocolIPv6:        "disabled"
									httpPutResponseHopLimit: 2
									httpTokens:              "required"
								}
								description: """
		MetadataOptions for the generated launch template of provisioned nodes. 
		 This specifies the exposure of the Instance Metadata Service to provisioned EC2 nodes. For more information, see Instance Metadata and User Data (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) in the Amazon Elastic Compute Cloud User Guide. 
		 Refer to recommended, security best practices (https://aws.github.io/aws-eks-best-practices/security/docs/iam/#restrict-access-to-the-instance-profile-assigned-to-the-worker-node) for limiting exposure of Instance Metadata and User Data to pods. If omitted, defaults to httpEndpoint enabled, with httpProtocolIPv6 disabled, with httpPutResponseLimit of 2, and with httpTokens required.
		"""

								properties: {
									httpEndpoint: {
										default: "enabled"
										description: """
		HTTPEndpoint enables or disables the HTTP metadata endpoint on provisioned nodes. If metadata options is non-nil, but this parameter is not specified, the default state is \"enabled\". 
		 If you specify a value of \"disabled\", instance metadata will not be accessible on the node.
		"""

										enum: [
											"enabled",
											"disabled",
										]
										type: "string"
									}
									httpProtocolIPv6: {
										default:     "disabled"
										description: "HTTPProtocolIPv6 enables or disables the IPv6 endpoint for the instance metadata service on provisioned nodes. If metadata options is non-nil, but this parameter is not specified, the default state is \"disabled\"."

										enum: [
											"enabled",
											"disabled",
										]
										type: "string"
									}
									httpPutResponseHopLimit: {
										default:     2
										description: "HTTPPutResponseHopLimit is the desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. Possible values are integers from 1 to 64. If metadata options is non-nil, but this parameter is not specified, the default value is 2."

										format:  "int64"
										maximum: 64
										minimum: 1
										type:    "integer"
									}
									httpTokens: {
										default: "required"
										description: """
		HTTPTokens determines the state of token usage for instance metadata requests. If metadata options is non-nil, but this parameter is not specified, the default state is \"required\". 
		 If the state is optional, one can choose to retrieve instance metadata with or without a signed token header on the request. If one retrieves the IAM role credentials without a token, the version 1.0 role credentials are returned. If one retrieves the IAM role credentials using a valid signed token, the version 2.0 role credentials are returned. 
		 If the state is \"required\", one must send a signed token header with any instance metadata retrieval requests. In this state, retrieving the IAM role credentials always returns the version 2.0 credentials; the version 1.0 credentials are not available.
		"""

										enum: [
											"required",
											"optional",
										]
										type: "string"
									}
								}
								type: "object"
							}
							role: {
								description: "Role is the AWS identity that nodes use. This field is immutable. This field is mutually exclusive from instanceProfile. Marking this field as immutable avoids concerns around terminating managed instance profiles from running instances. This field may be made mutable in the future, assuming the correct garbage collection and drift handling is implemented for the old instance profiles on an update."

								type: "string"
								"x-kubernetes-validations": [{
									message: "role cannot be empty"
									rule:    "self != ''"
								}, {
									message: "immutable field changed"
									rule:    "self == oldSelf"
								}]
							}
							securityGroupSelectorTerms: {
								description: "SecurityGroupSelectorTerms is a list of or security group selector terms. The terms are ORed."

								items: {
									description: "SecurityGroupSelectorTerm defines selection logic for a security group used by Karpenter to launch nodes. If multiple fields are used for selection, the requirements are ANDed."

									properties: {
										id: {
											description: "ID is the security group id in EC2"
											pattern:     "sg-[0-9a-z]+"
											type:        "string"
										}
										name: {
											description: "Name is the security group name in EC2. This value is the name field, which is different from the name tag."

											type: "string"
										}
										tags: {
											additionalProperties: type: "string"
											description: "Tags is a map of key/value tags used to select subnets Specifying '*' for a value selects all values for a given tag key."

											maxProperties: 20
											type:          "object"
											"x-kubernetes-validations": [{
												message: "empty tag keys or values aren't supported"
												rule:    "self.all(k, k != '' && self[k] != '')"
											}]
										}
									}
									type: "object"
								}
								maxItems: 30
								type:     "array"
								"x-kubernetes-validations": [{
									message: "securityGroupSelectorTerms cannot be empty"
									rule:    "self.size() != 0"
								}, {
									message: "expected at least one, got none, ['tags', 'id', 'name']"
									rule:    "self.all(x, has(x.tags) || has(x.id) || has(x.name))"
								}, {
									message: "'id' is mutually exclusive, cannot be set with a combination of other fields in securityGroupSelectorTerms"

									rule: "!self.all(x, has(x.id) && (has(x.tags) || has(x.name)))"
								}, {
									message: "'name' is mutually exclusive, cannot be set with a combination of other fields in securityGroupSelectorTerms"

									rule: "!self.all(x, has(x.name) && (has(x.tags) || has(x.id)))"
								}]
							}
							subnetSelectorTerms: {
								description: "SubnetSelectorTerms is a list of or subnet selector terms. The terms are ORed."

								items: {
									description: "SubnetSelectorTerm defines selection logic for a subnet used by Karpenter to launch nodes. If multiple fields are used for selection, the requirements are ANDed."

									properties: {
										id: {
											description: "ID is the subnet id in EC2"
											pattern:     "subnet-[0-9a-z]+"
											type:        "string"
										}
										tags: {
											additionalProperties: type: "string"
											description: "Tags is a map of key/value tags used to select subnets Specifying '*' for a value selects all values for a given tag key."

											maxProperties: 20
											type:          "object"
											"x-kubernetes-validations": [{
												message: "empty tag keys or values aren't supported"
												rule:    "self.all(k, k != '' && self[k] != '')"
											}]
										}
									}
									type: "object"
								}
								maxItems: 30
								type:     "array"
								"x-kubernetes-validations": [{
									message: "subnetSelectorTerms cannot be empty"
									rule:    "self.size() != 0"
								}, {
									message: "expected at least one, got none, ['tags', 'id']"
									rule:    "self.all(x, has(x.tags) || has(x.id))"
								}, {
									message: "'id' is mutually exclusive, cannot be set with a combination of other fields in subnetSelectorTerms"

									rule: "!self.all(x, has(x.id) && has(x.tags))"
								}]
							}
							tags: {
								additionalProperties: type: "string"
								description: "Tags to be applied on ec2 resources like instances and launch templates."

								type: "object"
								"x-kubernetes-validations": [{
									message: "empty tag keys aren't supported"
									rule:    "self.all(k, k != '')"
								}, {
									message: "tag contains a restricted tag matching kubernetes.io/cluster/"
									rule:    "self.all(k, !k.startsWith('kubernetes.io/cluster') )"
								}, {
									message: "tag contains a restricted tag matching karpenter.sh/provisioner-name"
									rule:    "self.all(k, k != 'karpenter.sh/provisioner-name')"
								}, {
									message: "tag contains a restricted tag matching karpenter.sh/nodepool"
									rule:    "self.all(k, k != 'karpenter.sh/nodepool')"
								}, {
									message: "tag contains a restricted tag matching karpenter.sh/managed-by"
									rule:    "self.all(k, k !='karpenter.sh/managed-by')"
								}]
							}
							userData: {
								description: "UserData to be applied to the provisioned nodes. It must be in the appropriate format based on the AMIFamily in use. Karpenter will merge certain fields into this UserData to ensure nodes are being provisioned with the correct configuration."

								type: "string"
							}
						}
						required: [
							"amiFamily",
							"securityGroupSelectorTerms",
							"subnetSelectorTerms",
						]
						type: "object"
						"x-kubernetes-validations": [{
							message: "amiSelectorTerms is required when amiFamily == 'Custom'"
							rule:    "self.amiFamily == 'Custom' ? self.amiSelectorTerms.size() != 0 : true"
						}, {
							message: "must specify exactly one of ['role', 'instanceProfile']"
							rule:    "(has(self.role) && !has(self.instanceProfile)) || (!has(self.role) && has(self.instanceProfile))"
						}, {
							message: "changing from 'instanceProfile' to 'role' is not supported. You must delete and recreate this node class if you want to change this."

							rule: "(has(oldSelf.role) && has(self.role)) || (has(oldSelf.instanceProfile) && has(self.instanceProfile))"
						}]
					}

					status: {
						description: "EC2NodeClassStatus contains the resolved state of the EC2NodeClass"
						properties: {
							amis: {
								description: "AMI contains the current AMI values that are available to the cluster under the AMI selectors."

								items: {
									description: "AMI contains resolved AMI selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the AMI"
											type:        "string"
										}
										name: {
											description: "Name of the AMI"
											type:        "string"
										}
										requirements: {
											description: "Requirements of the AMI to be utilized on an instance type"

											items: {
												description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

												properties: {
													key: {
														description: "The label key that the selector applies to."
														type:        "string"
													}
													operator: {
														description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

														type: "string"
													}
													values: {
														description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

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
									}
									required: [
										"id",
										"requirements",
									]
									type: "object"
								}
								type: "array"
							}
							instanceProfile: {
								description: "InstanceProfile contains the resolved instance profile for the role"

								type: "string"
							}
							securityGroups: {
								description: "SecurityGroups contains the current Security Groups values that are available to the cluster under the SecurityGroups selectors."

								items: {
									description: "SecurityGroup contains resolved SecurityGroup selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the security group"
											type:        "string"
										}
										name: {
											description: "Name of the security group"
											type:        "string"
										}
									}
									required: ["id"]
									type: "object"
								}
								type: "array"
							}
							subnets: {
								description: "Subnets contains the current Subnet values that are available to the cluster under the subnet selectors."

								items: {
									description: "Subnet contains resolved Subnet selector values utilized for node launch"

									properties: {
										id: {
											description: "ID of the subnet"
											type:        "string"
										}
										zone: {
											description: "The associated availability zone"
											type:        "string"
										}
									}
									required: [
										"id",
										"zone",
									]
									type: "object"
								}
								type: "array"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "machines.karpenter.sh": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "machines.karpenter.sh"
	}
	spec: {
		group: "karpenter.sh"
		names: {
			categories: ["karpenter"]
			kind:     "Machine"
			listKind: "MachineList"
			plural:   "machines"
			singular: "machine"
		}
		scope: "Cluster"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".metadata.labels.node\\.kubernetes\\.io/instance-type"
				name:     "Type"
				type:     "string"
			}, {
				jsonPath: ".metadata.labels.topology\\.kubernetes\\.io/zone"
				name:     "Zone"
				type:     "string"
			}, {
				jsonPath: ".status.nodeName"
				name:     "Node"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".metadata.labels.karpenter\\.sh/capacity-type"
				name:     "Capacity"
				priority: 1
				type:     "string"
			}, {
				jsonPath: ".metadata.labels.karpenter\\.sh/provisioner-name"
				name:     "Provisioner"
				priority: 1
				type:     "string"
			}, {
				jsonPath: ".spec.machineTemplateRef.name"
				name:     "Template"
				priority: 1
				type:     "string"
			}]
			name: "v1alpha5"
			schema: openAPIV3Schema: {
				description: "Machine is the Schema for the Machines API"
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
						description: "MachineSpec describes the desired state of the Machine"
						properties: {
							kubelet: {
								description: "Kubelet are options passed to the kubelet when provisioning nodes"

								properties: {
									clusterDNS: {
										description: "clusterDNS is a list of IP addresses for the cluster DNS server. Note that not all providers may use all addresses."

										items: type: "string"
										type: "array"
									}
									containerRuntime: {
										description: "ContainerRuntime is the container runtime to be used with your worker nodes."

										type: "string"
									}
									cpuCFSQuota: {
										description: "CPUCFSQuota enables CPU CFS quota enforcement for containers that specify CPU limits."

										type: "boolean"
									}
									evictionHard: {
										additionalProperties: type: "string"
										description: "EvictionHard is the map of signal names to quantities that define hard eviction thresholds"

										type: "object"
									}
									evictionMaxPodGracePeriod: {
										description: "EvictionMaxPodGracePeriod is the maximum allowed grace period (in seconds) to use when terminating pods in response to soft eviction thresholds being met."

										format: "int32"
										type:   "integer"
									}
									evictionSoft: {
										additionalProperties: type: "string"
										description: "EvictionSoft is the map of signal names to quantities that define soft eviction thresholds"

										type: "object"
									}
									evictionSoftGracePeriod: {
										additionalProperties: type: "string"
										description: "EvictionSoftGracePeriod is the map of signal names to quantities that define grace periods for each eviction signal"

										type: "object"
									}
									imageGCHighThresholdPercent: {
										description: "ImageGCHighThresholdPercent is the percent of disk usage after which image garbage collection is always run. The percent is calculated by dividing this field value by 100, so this field must be between 0 and 100, inclusive. When specified, the value must be greater than ImageGCLowThresholdPercent."

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									imageGCLowThresholdPercent: {
										description: "ImageGCLowThresholdPercent is the percent of disk usage before which image garbage collection is never run. Lowest disk usage to garbage collect to. The percent is calculated by dividing this field value by 100, so the field value must be between 0 and 100, inclusive. When specified, the value must be less than imageGCHighThresholdPercent"

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									kubeReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "KubeReserved contains resources reserved for Kubernetes system components."

										type: "object"
									}
									maxPods: {
										description: "MaxPods is an override for the maximum number of pods that can run on a worker node instance."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									podsPerCore: {
										description: "PodsPerCore is an override for the number of pods that can run on a worker node instance based on the number of cpu cores. This value cannot exceed MaxPods, so, if MaxPods is a lower value, that value will be used."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									systemReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "SystemReserved contains resources reserved for OS system daemons and kernel memory."

										type: "object"
									}
								}
								type: "object"
							}
							machineTemplateRef: {
								description: "MachineTemplateRef is a reference to an object that defines provider specific configuration"

								properties: {
									apiVersion: {
										description: "API version of the referent"
										type:        "string"
									}
									kind: {
										description: "Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\""
										type:        "string"
									}
									name: {
										description: "Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names"
										type:        "string"
									}
								}
								required: ["name"]
								type: "object"
							}
							requirements: {
								description: "Requirements are layered with Labels and applied to every node."

								items: {
									description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

									properties: {
										key: {
											description: "The label key that the selector applies to."
											type:        "string"
										}
										operator: {
											description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

											type: "string"
										}
										values: {
											description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

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
							resources: {
								description: "Resources models the resource requirements for the Machine to launch"

								properties: requests: {
									additionalProperties: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
										"x-kubernetes-int-or-string": true
									}
									description: "Requests describes the minimum required resources for the Machine to launch"

									type: "object"
								}
								type: "object"
							}
							startupTaints: {
								description: "StartupTaints are taints that are applied to nodes upon startup which are expected to be removed automatically within a short period of time, typically by a DaemonSet that tolerates the taint. These are commonly used by daemonsets to allow initialization and enforce startup ordering.  StartupTaints are ignored for provisioning purposes in that pods are not required to tolerate a StartupTaint in order to have nodes provisioned for them."

								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
							taints: {
								description: "Taints will be applied to the machine's node."
								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
						}
						type: "object"
					}
					status: {
						description: "MachineStatus defines the observed state of Machine"
						properties: {
							allocatable: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Allocatable is the estimated allocatable capacity of the machine"

								type: "object"
							}
							capacity: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Capacity is the estimated full capacity of the machine"
								type:        "object"
							}
							conditions: {
								description: "Conditions contains signals for health and readiness"
								items: {
									description: "Condition defines a readiness condition for a Knative resource. See: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#typical-status-properties"

									properties: {
										lastTransitionTime: {
											description: "LastTransitionTime is the last time the condition transitioned from one status to another. We use VolatileTime in place of metav1.Time to exclude this from creating equality.Semantic differences (all other things held constant)."

											type: "string"
										}
										message: {
											description: "A human readable message indicating details about the transition."

											type: "string"
										}
										reason: {
											description: "The reason for the condition's last transition."
											type:        "string"
										}
										severity: {
											description: "Severity with which to treat failures of this type of condition. When this is not specified, it defaults to Error."

											type: "string"
										}
										status: {
											description: "Status of the condition, one of True, False, Unknown."
											type:        "string"
										}
										type: {
											description: "Type of condition."
											type:        "string"
										}
									}
									required: [
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							nodeName: {
								description: "NodeName is the name of the corresponding node object"
								type:        "string"
							}
							providerID: {
								description: "ProviderID of the corresponding node object"
								type:        "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "nodeclaims.karpenter.sh": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "nodeclaims.karpenter.sh"
	}
	spec: {
		group: "karpenter.sh"
		names: {
			categories: ["karpenter"]
			kind:     "NodeClaim"
			listKind: "NodeClaimList"
			plural:   "nodeclaims"
			singular: "nodeclaim"
		}
		scope: "Cluster"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".metadata.labels.node\\.kubernetes\\.io/instance-type"
				name:     "Type"
				type:     "string"
			}, {
				jsonPath: ".metadata.labels.topology\\.kubernetes\\.io/zone"
				name:     "Zone"
				type:     "string"
			}, {
				jsonPath: ".status.nodeName"
				name:     "Node"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".metadata.labels.karpenter\\.sh/capacity-type"
				name:     "Capacity"
				priority: 1
				type:     "string"
			}, {
				jsonPath: ".metadata.labels.karpenter\\.sh/nodepool"
				name:     "NodePool"
				priority: 1
				type:     "string"
			}, {
				jsonPath: ".spec.nodeClassRef.name"
				name:     "NodeClass"
				priority: 1
				type:     "string"
			}]
			name: "v1beta1"
			schema: openAPIV3Schema: {
				description: "NodeClaim is the Schema for the NodeClaims API"
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
						description: "NodeClaimSpec describes the desired state of the NodeClaim"
						properties: {
							kubelet: {
								description: "Kubelet defines args to be used when configuring kubelet on provisioned nodes. They are a subset of the upstream types, recognizing not all options may be supported. Wherever possible, the types and names should reflect the upstream kubelet types."

								properties: {
									clusterDNS: {
										description: "clusterDNS is a list of IP addresses for the cluster DNS server. Note that not all providers may use all addresses."

										items: type: "string"
										type: "array"
									}
									cpuCFSQuota: {
										description: "CPUCFSQuota enables CPU CFS quota enforcement for containers that specify CPU limits."

										type: "boolean"
									}
									evictionHard: {
										additionalProperties: {
											pattern: "^((\\d{1,2}(\\.\\d{1,2})?|100(\\.0{1,2})?)%||(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?)$"
											type:    "string"
										}
										description: "EvictionHard is the map of signal names to quantities that define hard eviction thresholds"

										type: "object"
										"x-kubernetes-validations": [{
											message: "valid keys for evictionHard are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"
											rule:    "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
										}]
									}
									evictionMaxPodGracePeriod: {
										description: "EvictionMaxPodGracePeriod is the maximum allowed grace period (in seconds) to use when terminating pods in response to soft eviction thresholds being met."

										format: "int32"
										type:   "integer"
									}
									evictionSoft: {
										additionalProperties: {
											pattern: "^((\\d{1,2}(\\.\\d{1,2})?|100(\\.0{1,2})?)%||(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?)$"
											type:    "string"
										}
										description: "EvictionSoft is the map of signal names to quantities that define soft eviction thresholds"

										type: "object"
										"x-kubernetes-validations": [{
											message: "valid keys for evictionSoft are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"
											rule:    "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
										}]
									}
									evictionSoftGracePeriod: {
										additionalProperties: type: "string"
										description: "EvictionSoftGracePeriod is the map of signal names to quantities that define grace periods for each eviction signal"

										type: "object"
										"x-kubernetes-validations": [{
											message: "valid keys for evictionSoftGracePeriod are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"
											rule:    "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
										}]
									}
									imageGCHighThresholdPercent: {
										description: "ImageGCHighThresholdPercent is the percent of disk usage after which image garbage collection is always run. The percent is calculated by dividing this field value by 100, so this field must be between 0 and 100, inclusive. When specified, the value must be greater than ImageGCLowThresholdPercent."

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									imageGCLowThresholdPercent: {
										description: "ImageGCLowThresholdPercent is the percent of disk usage before which image garbage collection is never run. Lowest disk usage to garbage collect to. The percent is calculated by dividing this field value by 100, so the field value must be between 0 and 100, inclusive. When specified, the value must be less than imageGCHighThresholdPercent"

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									kubeReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "KubeReserved contains resources reserved for Kubernetes system components."

										type: "object"
										"x-kubernetes-validations": [{
											message: "valid keys for kubeReserved are ['cpu','memory','ephemeral-storage','pid']"
											rule:    "self.all(x, x=='cpu' || x=='memory' || x=='ephemeral-storage' || x=='pid')"
										}, {
											message: "kubeReserved value cannot be a negative resource quantity"
											rule:    "self.all(x, !self[x].startsWith('-'))"
										}]
									}
									maxPods: {
										description: "MaxPods is an override for the maximum number of pods that can run on a worker node instance."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									podsPerCore: {
										description: "PodsPerCore is an override for the number of pods that can run on a worker node instance based on the number of cpu cores. This value cannot exceed MaxPods, so, if MaxPods is a lower value, that value will be used."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									systemReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "SystemReserved contains resources reserved for OS system daemons and kernel memory."

										type: "object"
										"x-kubernetes-validations": [{
											message: "valid keys for systemReserved are ['cpu','memory','ephemeral-storage','pid']"
											rule:    "self.all(x, x=='cpu' || x=='memory' || x=='ephemeral-storage' || x=='pid')"
										}, {
											message: "systemReserved value cannot be a negative resource quantity"

											rule: "self.all(x, !self[x].startsWith('-'))"
										}]
									}
								}
								type: "object"
								"x-kubernetes-validations": [{
									message: "imageGCHighThresholdPercent must be greater than imageGCLowThresholdPercent"
									rule:    "has(self.imageGCHighThresholdPercent) && has(self.imageGCLowThresholdPercent) ?  self.imageGCHighThresholdPercent > self.imageGCLowThresholdPercent  : true"
								}, {
									message: "evictionSoft OwnerKey does not have a matching evictionSoftGracePeriod"
									rule:    "has(self.evictionSoft) ? self.evictionSoft.all(e, (e in self.evictionSoftGracePeriod)):true"
								}, {
									message: "evictionSoftGracePeriod OwnerKey does not have a matching evictionSoft"

									rule: "has(self.evictionSoftGracePeriod) ? self.evictionSoftGracePeriod.all(e, (e in self.evictionSoft)):true"
								}]
							}

							nodeClassRef: {
								description: "NodeClassRef is a reference to an object that defines provider specific configuration"

								properties: {
									apiVersion: {
										description: "API version of the referent"
										type:        "string"
									}
									kind: {
										description: "Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\""
										type:        "string"
									}
									name: {
										description: "Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names"
										type:        "string"
									}
								}
								required: ["name"]
								type: "object"
							}
							requirements: {
								description: "Requirements are layered with GetLabels and applied to every node."

								items: {
									description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

									properties: {
										key: {
											description: "The label key that the selector applies to."
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
											type:        "string"
											"x-kubernetes-validations": [{
												message: "label domain \"kubernetes.io\" is restricted"
												rule:    "self in [\"beta.kubernetes.io/instance-type\", \"failure-domain.beta.kubernetes.io/region\", \"beta.kubernetes.io/os\", \"beta.kubernetes.io/arch\", \"failure-domain.beta.kubernetes.io/zone\", \"topology.kubernetes.io/zone\", \"topology.kubernetes.io/region\", \"node.kubernetes.io/instance-type\", \"kubernetes.io/arch\", \"kubernetes.io/os\", \"node.kubernetes.io/windows-build\"] || self.find(\"^([^/]+)\").endsWith(\"node.kubernetes.io\") || self.find(\"^([^/]+)\").endsWith(\"node-restriction.kubernetes.io\") || !self.find(\"^([^/]+)\").endsWith(\"kubernetes.io\")"
											}, {
												message: "label domain \"k8s.io\" is restricted"
												rule:    "self.find(\"^([^/]+)\").endsWith(\"kops.k8s.io\") || !self.find(\"^([^/]+)\").endsWith(\"k8s.io\")"
											}, {
												message: "label domain \"karpenter.sh\" is restricted"
												rule:    "self in [\"karpenter.sh/capacity-type\", \"karpenter.sh/nodepool\"] || !self.find(\"^([^/]+)\").endsWith(\"karpenter.sh\")"
											}, {
												message: "label \"kubernetes.io/hostname\" is restricted"
												rule:    "self != \"kubernetes.io/hostname\""
											}, {
												message: "label domain \"karpenter.k8s.aws\" is restricted"
												rule:    "self in [\"karpenter.k8s.aws/instance-encryption-in-transit-supported\", \"karpenter.k8s.aws/instance-category\", \"karpenter.k8s.aws/instance-hypervisor\", \"karpenter.k8s.aws/instance-family\", \"karpenter.k8s.aws/instance-generation\", \"karpenter.k8s.aws/instance-local-nvme\", \"karpenter.k8s.aws/instance-size\", \"karpenter.k8s.aws/instance-cpu\",\"karpenter.k8s.aws/instance-memory\", \"karpenter.k8s.aws/instance-network-bandwidth\", \"karpenter.k8s.aws/instance-gpu-name\", \"karpenter.k8s.aws/instance-gpu-manufacturer\", \"karpenter.k8s.aws/instance-gpu-count\", \"karpenter.k8s.aws/instance-gpu-memory\", \"karpenter.k8s.aws/instance-accelerator-name\", \"karpenter.k8s.aws/instance-accelerator-manufacturer\", \"karpenter.k8s.aws/instance-accelerator-count\"] || !self.find(\"^([^/]+)\").endsWith(\"karpenter.k8s.aws\")"
											}]
										}

										operator: {
											description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

											enum: [
												"In",
												"NotIn",
												"Exists",
												"DoesNotExist",
												"Gt",
												"Lt",
											]
											type: "string"
										}
										values: {
											description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

											items: type: "string"
											maxLength: 63
											pattern:   "^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
											type:      "array"
										}
									}
									required: [
										"key",
										"operator",
									]
									type: "object"
								}
								maxItems: 30
								type:     "array"
								"x-kubernetes-validations": [{
									message: "requirements with operator 'In' must have a value defined"
									rule:    "self.all(x, x.operator == 'In' ? x.values.size() != 0 : true)"
								}, {
									message: "requirements operator 'Gt' or 'Lt' must have a single positive integer value"

									rule: "self.all(x, (x.operator == 'Gt' || x.operator == 'Lt') ? (x.values.size() == 1 && int(x.values[0]) >= 0) : true)"
								}]
							}

							resources: {
								description: "Resources models the resource requirements for the NodeClaim to launch"

								properties: requests: {
									additionalProperties: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
										"x-kubernetes-int-or-string": true
									}
									description: "Requests describes the minimum required resources for the NodeClaim to launch"

									type: "object"
								}
								type: "object"
							}
							startupTaints: {
								description: "StartupTaints are taints that are applied to nodes upon startup which are expected to be removed automatically within a short period of time, typically by a DaemonSet that tolerates the taint. These are commonly used by daemonsets to allow initialization and enforce startup ordering.  StartupTaints are ignored for provisioning purposes in that pods are not required to tolerate a StartupTaint in order to have nodes provisioned for them."

								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											enum: [
												"NoSchedule",
												"PreferNoSchedule",
												"NoExecute",
											]
											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											minLength:   1
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
							taints: {
								description: "Taints will be applied to the NodeClaim's node."
								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											enum: [
												"NoSchedule",
												"PreferNoSchedule",
												"NoExecute",
											]
											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											minLength:   1
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
						}
						required: [
							"nodeClassRef",
							"requirements",
						]
						type: "object"
					}
					status: {
						description: "NodeClaimStatus defines the observed state of NodeClaim"
						properties: {
							allocatable: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Allocatable is the estimated allocatable capacity of the node"

								type: "object"
							}
							capacity: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Capacity is the estimated full capacity of the node"
								type:        "object"
							}
							conditions: {
								description: "Conditions contains signals for health and readiness"
								items: {
									description: "Condition defines a readiness condition for a Knative resource. See: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#typical-status-properties"

									properties: {
										lastTransitionTime: {
											description: "LastTransitionTime is the last time the condition transitioned from one status to another. We use VolatileTime in place of metav1.Time to exclude this from creating equality.Semantic differences (all other things held constant)."

											type: "string"
										}
										message: {
											description: "A human readable message indicating details about the transition."

											type: "string"
										}
										reason: {
											description: "The reason for the condition's last transition."
											type:        "string"
										}
										severity: {
											description: "Severity with which to treat failures of this type of condition. When this is not specified, it defaults to Error."

											type: "string"
										}
										status: {
											description: "Status of the condition, one of True, False, Unknown."
											type:        "string"
										}
										type: {
											description: "Type of condition."
											type:        "string"
										}
									}
									required: [
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							imageID: {
								description: "ImageID is an identifier for the image that runs on the node"

								type: "string"
							}
							nodeName: {
								description: "NodeName is the name of the corresponding node object"
								type:        "string"
							}
							providerID: {
								description: "ProviderID of the corresponding node object"
								type:        "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "nodepools.karpenter.sh": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "nodepools.karpenter.sh"
	}
	spec: {
		group: "karpenter.sh"
		names: {
			categories: ["karpenter"]
			kind:     "NodePool"
			listKind: "NodePoolList"
			plural:   "nodepools"
			singular: "nodepool"
		}
		scope: "Cluster"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".spec.template.spec.nodeClassRef.name"
				name:     "NodeClass"
				type:     "string"
			}, {
				jsonPath: ".spec.weight"
				name:     "Weight"
				priority: 1
				type:     "string"
			}]
			name: "v1beta1"
			schema: openAPIV3Schema: {
				description: "NodePool is the Schema for the NodePools API"
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
						description: "NodePoolSpec is the top level provisioner specification. Provisioners launch nodes in response to pods that are unschedulable. A single provisioner is capable of managing a diverse set of nodes. Node properties are determined from a combination of provisioner and pod scheduling constraints."

						properties: {
							disruption: {
								default: {
									consolidationPolicy: "WhenUnderutilized"
									expireAfter:         "720h"
								}
								description: "Disruption contains the parameters that relate to Karpenter's disruption logic"

								properties: {
									consolidateAfter: {
										description: "ConsolidateAfter is the duration the controller will wait before attempting to terminate nodes that are underutilized. Refer to ConsolidationPolicy for how underutilization is considered."

										pattern: "^(([0-9]+(s|m|h))+)|(Never)$"
										type:    "string"
									}
									consolidationPolicy: {
										default:     "WhenUnderutilized"
										description: "ConsolidationPolicy describes which nodes Karpenter can disrupt through its consolidation algorithm. This policy defaults to \"WhenUnderutilized\" if not specified"

										enum: [
											"WhenEmpty",
											"WhenUnderutilized",
										]
										type: "string"
									}
									expireAfter: {
										default:     "720h"
										description: "ExpireAfter is the duration the controller will wait before terminating a node, measured from when the node is created. This is useful to implement features like eventually consistent node upgrade, memory leak protection, and disruption testing."

										pattern: "^(([0-9]+(s|m|h))+)|(Never)$"
										type:    "string"
									}
								}
								type: "object"
								"x-kubernetes-validations": [{
									message: "consolidateAfter cannot be combined with consolidationPolicy=WhenUnderutilized"
									rule:    "has(self.consolidateAfter) ? self.consolidationPolicy != 'WhenUnderutilized' || self.consolidateAfter == 'Never' : true"
								}, {
									message: "consolidateAfter must be specified with consolidationPolicy=WhenEmpty"
									rule:    "self.consolidationPolicy == 'WhenEmpty' ? has(self.consolidateAfter) : true"
								}]
							}

							limits: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Limits define a set of bounds for provisioning capacity."
								type:        "object"
							}
							template: {
								description: "Template contains the template of possibilities for the provisioning logic to launch a NodeClaim with. NodeClaims launched from this NodePool will often be further constrained than the template specifies."

								properties: {
									metadata: {
										properties: {
											annotations: {
												additionalProperties: type: "string"
												description: "Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations"

												type: "object"
											}
											labels: {
												additionalProperties: {
													maxLength: 63
													pattern:   "^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
													type:      "string"
												}
												description: "Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels"

												maxProperties: 100
												type:          "object"
												"x-kubernetes-validations": [{
													message: "label domain \"kubernetes.io\" is restricted"
													rule:    "self.all(x, x in [\"beta.kubernetes.io/instance-type\", \"failure-domain.beta.kubernetes.io/region\",  \"beta.kubernetes.io/os\", \"beta.kubernetes.io/arch\", \"failure-domain.beta.kubernetes.io/zone\", \"topology.kubernetes.io/zone\", \"topology.kubernetes.io/region\", \"kubernetes.io/arch\", \"kubernetes.io/os\", \"node.kubernetes.io/windows-build\"] || x.find(\"^([^/]+)\").endsWith(\"node.kubernetes.io\") || x.find(\"^([^/]+)\").endsWith(\"node-restriction.kubernetes.io\") || !x.find(\"^([^/]+)\").endsWith(\"kubernetes.io\"))"
												}, {
													message: "label domain \"k8s.io\" is restricted"
													rule:    "self.all(x, x.find(\"^([^/]+)\").endsWith(\"kops.k8s.io\") || !x.find(\"^([^/]+)\").endsWith(\"k8s.io\"))"
												}, {
													message: "label domain \"karpenter.sh\" is restricted"
													rule:    "self.all(x, x in [\"karpenter.sh/capacity-type\", \"karpenter.sh/nodepool\"] || !x.find(\"^([^/]+)\").endsWith(\"karpenter.sh\"))"
												}, {
													message: "label \"karpenter.sh/nodepool\" is restricted"
													rule:    "self.all(x, x != \"karpenter.sh/nodepool\")"
												}, {
													message: "label \"kubernetes.io/hostname\" is restricted"
													rule:    "self.all(x, x != \"kubernetes.io/hostname\")"
												}, {
													message: "label domain \"karpenter.k8s.aws\" is restricted"
													rule:    "self.all(x, x in [\"karpenter.k8s.aws/instance-encryption-in-transit-supported\", \"karpenter.k8s.aws/instance-category\", \"karpenter.k8s.aws/instance-hypervisor\", \"karpenter.k8s.aws/instance-family\", \"karpenter.k8s.aws/instance-generation\", \"karpenter.k8s.aws/instance-local-nvme\", \"karpenter.k8s.aws/instance-size\", \"karpenter.k8s.aws/instance-cpu\",\"karpenter.k8s.aws/instance-memory\", \"karpenter.k8s.aws/instance-network-bandwidth\", \"karpenter.k8s.aws/instance-gpu-name\", \"karpenter.k8s.aws/instance-gpu-manufacturer\", \"karpenter.k8s.aws/instance-gpu-count\", \"karpenter.k8s.aws/instance-gpu-memory\", \"karpenter.k8s.aws/instance-accelerator-name\", \"karpenter.k8s.aws/instance-accelerator-manufacturer\", \"karpenter.k8s.aws/instance-accelerator-count\"] || !x.find(\"^([^/]+)\").endsWith(\"karpenter.k8s.aws\"))"
												}]
											}
										}

										type: "object"
									}
									spec: {
										description: "NodeClaimSpec describes the desired state of the NodeClaim"

										properties: {
											kubelet: {
												description: "Kubelet defines args to be used when configuring kubelet on provisioned nodes. They are a subset of the upstream types, recognizing not all options may be supported. Wherever possible, the types and names should reflect the upstream kubelet types."

												properties: {
													clusterDNS: {
														description: "clusterDNS is a list of IP addresses for the cluster DNS server. Note that not all providers may use all addresses."

														items: type: "string"
														type: "array"
													}
													cpuCFSQuota: {
														description: "CPUCFSQuota enables CPU CFS quota enforcement for containers that specify CPU limits."

														type: "boolean"
													}
													evictionHard: {
														additionalProperties: {
															pattern: "^((\\d{1,2}(\\.\\d{1,2})?|100(\\.0{1,2})?)%||(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?)$"
															type:    "string"
														}
														description: "EvictionHard is the map of signal names to quantities that define hard eviction thresholds"

														type: "object"
														"x-kubernetes-validations": [{
															message: "valid keys for evictionHard are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"
															rule:    "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
														}]
													}
													evictionMaxPodGracePeriod: {
														description: "EvictionMaxPodGracePeriod is the maximum allowed grace period (in seconds) to use when terminating pods in response to soft eviction thresholds being met."

														format: "int32"
														type:   "integer"
													}
													evictionSoft: {
														additionalProperties: {
															pattern: "^((\\d{1,2}(\\.\\d{1,2})?|100(\\.0{1,2})?)%||(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?)$"
															type:    "string"
														}
														description: "EvictionSoft is the map of signal names to quantities that define soft eviction thresholds"

														type: "object"
														"x-kubernetes-validations": [{
															message: "valid keys for evictionSoft are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"
															rule:    "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
														}]
													}
													evictionSoftGracePeriod: {
														additionalProperties: type: "string"
														description: "EvictionSoftGracePeriod is the map of signal names to quantities that define grace periods for each eviction signal"

														type: "object"
														"x-kubernetes-validations": [{
															message: "valid keys for evictionSoftGracePeriod are ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available']"

															rule: "self.all(x, x in ['memory.available','nodefs.available','nodefs.inodesFree','imagefs.available','imagefs.inodesFree','pid.available'])"
														}]
													}
													imageGCHighThresholdPercent: {
														description: "ImageGCHighThresholdPercent is the percent of disk usage after which image garbage collection is always run. The percent is calculated by dividing this field value by 100, so this field must be between 0 and 100, inclusive. When specified, the value must be greater than ImageGCLowThresholdPercent."

														format:  "int32"
														maximum: 100
														minimum: 0
														type:    "integer"
													}
													imageGCLowThresholdPercent: {
														description: "ImageGCLowThresholdPercent is the percent of disk usage before which image garbage collection is never run. Lowest disk usage to garbage collect to. The percent is calculated by dividing this field value by 100, so the field value must be between 0 and 100, inclusive. When specified, the value must be less than imageGCHighThresholdPercent"

														format:  "int32"
														maximum: 100
														minimum: 0
														type:    "integer"
													}
													kubeReserved: {
														additionalProperties: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
															"x-kubernetes-int-or-string": true
														}
														description: "KubeReserved contains resources reserved for Kubernetes system components."

														type: "object"
														"x-kubernetes-validations": [{
															message: "valid keys for kubeReserved are ['cpu','memory','ephemeral-storage','pid']"
															rule:    "self.all(x, x=='cpu' || x=='memory' || x=='ephemeral-storage' || x=='pid')"
														}, {
															message: "kubeReserved value cannot be a negative resource quantity"

															rule: "self.all(x, !self[x].startsWith('-'))"
														}]
													}
													maxPods: {
														description: "MaxPods is an override for the maximum number of pods that can run on a worker node instance."

														format:  "int32"
														minimum: 0
														type:    "integer"
													}
													podsPerCore: {
														description: "PodsPerCore is an override for the number of pods that can run on a worker node instance based on the number of cpu cores. This value cannot exceed MaxPods, so, if MaxPods is a lower value, that value will be used."

														format:  "int32"
														minimum: 0
														type:    "integer"
													}
													systemReserved: {
														additionalProperties: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
															"x-kubernetes-int-or-string": true
														}
														description: "SystemReserved contains resources reserved for OS system daemons and kernel memory."

														type: "object"
														"x-kubernetes-validations": [{
															message: "valid keys for systemReserved are ['cpu','memory','ephemeral-storage','pid']"
															rule:    "self.all(x, x=='cpu' || x=='memory' || x=='ephemeral-storage' || x=='pid')"
														}, {
															message: "systemReserved value cannot be a negative resource quantity"

															rule: "self.all(x, !self[x].startsWith('-'))"
														}]
													}
												}
												type: "object"
												"x-kubernetes-validations": [{
													message: "imageGCHighThresholdPercent must be greater than imageGCLowThresholdPercent"

													rule: "has(self.imageGCHighThresholdPercent) && has(self.imageGCLowThresholdPercent) ?  self.imageGCHighThresholdPercent > self.imageGCLowThresholdPercent  : true"
												}, {
													message: "evictionSoft OwnerKey does not have a matching evictionSoftGracePeriod"

													rule: "has(self.evictionSoft) ? self.evictionSoft.all(e, (e in self.evictionSoftGracePeriod)):true"
												}, {
													message: "evictionSoftGracePeriod OwnerKey does not have a matching evictionSoft"

													rule: "has(self.evictionSoftGracePeriod) ? self.evictionSoftGracePeriod.all(e, (e in self.evictionSoft)):true"
												}]
											}

											nodeClassRef: {
												description: "NodeClassRef is a reference to an object that defines provider specific configuration"

												properties: {
													apiVersion: {
														description: "API version of the referent"
														type:        "string"
													}
													kind: {
														description: "Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\""
														type:        "string"
													}
													name: {
														description: "Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names"
														type:        "string"
													}
												}
												required: ["name"]
												type: "object"
											}
											requirements: {
												description: "Requirements are layered with GetLabels and applied to every node."

												items: {
													description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

													properties: {
														key: {
															description: "The label key that the selector applies to."

															maxLength: 316
															pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
															type:      "string"
															"x-kubernetes-validations": [{
																message: "label domain \"kubernetes.io\" is restricted"
																rule:    "self in [\"beta.kubernetes.io/instance-type\", \"failure-domain.beta.kubernetes.io/region\", \"beta.kubernetes.io/os\", \"beta.kubernetes.io/arch\", \"failure-domain.beta.kubernetes.io/zone\", \"topology.kubernetes.io/zone\", \"topology.kubernetes.io/region\", \"node.kubernetes.io/instance-type\", \"kubernetes.io/arch\", \"kubernetes.io/os\", \"node.kubernetes.io/windows-build\"] || self.find(\"^([^/]+)\").endsWith(\"node.kubernetes.io\") || self.find(\"^([^/]+)\").endsWith(\"node-restriction.kubernetes.io\") || !self.find(\"^([^/]+)\").endsWith(\"kubernetes.io\")"
															}, {
																message: "label domain \"k8s.io\" is restricted"
																rule:    "self.find(\"^([^/]+)\").endsWith(\"kops.k8s.io\") || !self.find(\"^([^/]+)\").endsWith(\"k8s.io\")"
															}, {
																message: "label domain \"karpenter.sh\" is restricted"
																rule:    "self in [\"karpenter.sh/capacity-type\", \"karpenter.sh/nodepool\"] || !self.find(\"^([^/]+)\").endsWith(\"karpenter.sh\")"
															}, {
																message: "label \"karpenter.sh/nodepool\" is restricted"
																rule:    "self != \"karpenter.sh/nodepool\""
															}, {
																message: "label \"kubernetes.io/hostname\" is restricted"
																rule:    "self != \"kubernetes.io/hostname\""
															}, {
																message: "label domain \"karpenter.k8s.aws\" is restricted"
																rule:    "self in [\"karpenter.k8s.aws/instance-encryption-in-transit-supported\", \"karpenter.k8s.aws/instance-category\", \"karpenter.k8s.aws/instance-hypervisor\", \"karpenter.k8s.aws/instance-family\", \"karpenter.k8s.aws/instance-generation\", \"karpenter.k8s.aws/instance-local-nvme\", \"karpenter.k8s.aws/instance-size\", \"karpenter.k8s.aws/instance-cpu\",\"karpenter.k8s.aws/instance-memory\", \"karpenter.k8s.aws/instance-network-bandwidth\", \"karpenter.k8s.aws/instance-gpu-name\", \"karpenter.k8s.aws/instance-gpu-manufacturer\", \"karpenter.k8s.aws/instance-gpu-count\", \"karpenter.k8s.aws/instance-gpu-memory\", \"karpenter.k8s.aws/instance-accelerator-name\", \"karpenter.k8s.aws/instance-accelerator-manufacturer\", \"karpenter.k8s.aws/instance-accelerator-count\"] || !self.find(\"^([^/]+)\").endsWith(\"karpenter.k8s.aws\")"
															}]
														}

														operator: {
															description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

															enum: [
																"In",
																"NotIn",
																"Exists",
																"DoesNotExist",
																"Gt",
																"Lt",
															]
															type: "string"
														}
														values: {
															description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

															items: type: "string"
															maxLength: 63
															pattern:   "^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
															type:      "array"
														}
													}
													required: [
														"key",
														"operator",
													]
													type: "object"
												}
												maxItems: 30
												type:     "array"
												"x-kubernetes-validations": [{
													message: "requirements with operator 'In' must have a value defined"

													rule: "self.all(x, x.operator == 'In' ? x.values.size() != 0 : true)"
												}, {
													message: "requirements operator 'Gt' or 'Lt' must have a single positive integer value"

													rule: "self.all(x, (x.operator == 'Gt' || x.operator == 'Lt') ? (x.values.size() == 1 && int(x.values[0]) >= 0) : true)"
												}]
											}

											resources: {
												description: "Resources models the resource requirements for the NodeClaim to launch"

												properties: requests: {
													additionalProperties: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
														"x-kubernetes-int-or-string": true
													}
													description: "Requests describes the minimum required resources for the NodeClaim to launch"

													type: "object"
												}
												type: "object"
											}
											startupTaints: {
												description: "StartupTaints are taints that are applied to nodes upon startup which are expected to be removed automatically within a short period of time, typically by a DaemonSet that tolerates the taint. These are commonly used by daemonsets to allow initialization and enforce startup ordering.  StartupTaints are ignored for provisioning purposes in that pods are not required to tolerate a StartupTaint in order to have nodes provisioned for them."

												items: {
													description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

													properties: {
														effect: {
															description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

															enum: [
																"NoSchedule",
																"PreferNoSchedule",
																"NoExecute",
															]
															type: "string"
														}
														key: {
															description: "Required. The taint key to be applied to a node."

															minLength: 1
															pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
															type:      "string"
														}
														timeAdded: {
															description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

															format: "date-time"
															type:   "string"
														}
														value: {
															description: "The taint value corresponding to the taint key."

															pattern: "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
															type:    "string"
														}
													}
													required: [
														"effect",
														"key",
													]
													type: "object"
												}
												type: "array"
											}
											taints: {
												description: "Taints will be applied to the NodeClaim's node."
												items: {
													description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

													properties: {
														effect: {
															description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

															enum: [
																"NoSchedule",
																"PreferNoSchedule",
																"NoExecute",
															]
															type: "string"
														}
														key: {
															description: "Required. The taint key to be applied to a node."

															minLength: 1
															pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
															type:      "string"
														}
														timeAdded: {
															description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

															format: "date-time"
															type:   "string"
														}
														value: {
															description: "The taint value corresponding to the taint key."

															pattern: "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*(\\/))?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
															type:    "string"
														}
													}
													required: [
														"effect",
														"key",
													]
													type: "object"
												}
												type: "array"
											}
										}
										required: [
											"nodeClassRef",
											"requirements",
										]
										type: "object"
									}
								}
								required: ["spec"]
								type: "object"
							}
							weight: {
								description: "Weight is the priority given to the provisioner during scheduling. A higher numerical weight indicates that this provisioner will be ordered ahead of other provisioners with lower weights. A provisioner with no weight will be treated as if it is a provisioner with a weight of 0."

								format:  "int32"
								maximum: 100
								minimum: 1
								type:    "integer"
							}
						}
						required: ["template"]
						type: "object"
					}
					status: {
						description: "NodePoolStatus defines the observed state of NodePool"
						properties: resources: {
							additionalProperties: {
								anyOf: [{
									type: "integer"
								}, {
									type: "string"
								}]
								pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
								"x-kubernetes-int-or-string": true
							}
							description: "Resources is the list of resources that have been provisioned."
							type:        "object"
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: customresourcedefinition: "coder-amanibhavam-class-cluster-karpenter": cluster: "provisioners.karpenter.sh": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "provisioners.karpenter.sh"
	}
	spec: {
		group: "karpenter.sh"
		names: {
			categories: ["karpenter"]
			kind:     "Provisioner"
			listKind: "ProvisionerList"
			plural:   "provisioners"
			singular: "provisioner"
		}
		scope: "Cluster"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".spec.providerRef.name"
				name:     "Template"
				type:     "string"
			}, {
				jsonPath: ".spec.weight"
				name:     "Weight"
				priority: 1
				type:     "string"
			}]
			name: "v1alpha5"
			schema: openAPIV3Schema: {
				description: "Provisioner is the Schema for the Provisioners API"
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
						description: "ProvisionerSpec is the top level provisioner specification. Provisioners launch nodes in response to pods that are unschedulable. A single provisioner is capable of managing a diverse set of nodes. Node properties are determined from a combination of provisioner and pod scheduling constraints."

						properties: {
							annotations: {
								additionalProperties: type: "string"
								description: "Annotations are applied to every node."
								type:        "object"
							}
							consolidation: {
								description: "Consolidation are the consolidation parameters"
								properties: enabled: {
									description: "Enabled enables consolidation if it has been set"
									type:        "boolean"
								}
								type: "object"
							}
							kubeletConfiguration: {
								description: "KubeletConfiguration are options passed to the kubelet when provisioning nodes"

								properties: {
									clusterDNS: {
										description: "clusterDNS is a list of IP addresses for the cluster DNS server. Note that not all providers may use all addresses."

										items: type: "string"
										type: "array"
									}
									containerRuntime: {
										description: "ContainerRuntime is the container runtime to be used with your worker nodes."

										type: "string"
									}
									cpuCFSQuota: {
										description: "CPUCFSQuota enables CPU CFS quota enforcement for containers that specify CPU limits."

										type: "boolean"
									}
									evictionHard: {
										additionalProperties: type: "string"
										description: "EvictionHard is the map of signal names to quantities that define hard eviction thresholds"

										type: "object"
									}
									evictionMaxPodGracePeriod: {
										description: "EvictionMaxPodGracePeriod is the maximum allowed grace period (in seconds) to use when terminating pods in response to soft eviction thresholds being met."

										format: "int32"
										type:   "integer"
									}
									evictionSoft: {
										additionalProperties: type: "string"
										description: "EvictionSoft is the map of signal names to quantities that define soft eviction thresholds"

										type: "object"
									}
									evictionSoftGracePeriod: {
										additionalProperties: type: "string"
										description: "EvictionSoftGracePeriod is the map of signal names to quantities that define grace periods for each eviction signal"

										type: "object"
									}
									imageGCHighThresholdPercent: {
										description: "ImageGCHighThresholdPercent is the percent of disk usage after which image garbage collection is always run. The percent is calculated by dividing this field value by 100, so this field must be between 0 and 100, inclusive. When specified, the value must be greater than ImageGCLowThresholdPercent."

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									imageGCLowThresholdPercent: {
										description: "ImageGCLowThresholdPercent is the percent of disk usage before which image garbage collection is never run. Lowest disk usage to garbage collect to. The percent is calculated by dividing this field value by 100, so the field value must be between 0 and 100, inclusive. When specified, the value must be less than imageGCHighThresholdPercent"

										format:  "int32"
										maximum: 100
										minimum: 0
										type:    "integer"
									}
									kubeReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "KubeReserved contains resources reserved for Kubernetes system components."

										type: "object"
									}
									maxPods: {
										description: "MaxPods is an override for the maximum number of pods that can run on a worker node instance."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									podsPerCore: {
										description: "PodsPerCore is an override for the number of pods that can run on a worker node instance based on the number of cpu cores. This value cannot exceed MaxPods, so, if MaxPods is a lower value, that value will be used."

										format:  "int32"
										minimum: 0
										type:    "integer"
									}
									systemReserved: {
										additionalProperties: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
											"x-kubernetes-int-or-string": true
										}
										description: "SystemReserved contains resources reserved for OS system daemons and kernel memory."

										type: "object"
									}
								}
								type: "object"
							}
							labels: {
								additionalProperties: type: "string"
								description: "Labels are layered with Requirements and applied to every node."

								type: "object"
							}
							limits: {
								description: "Limits define a set of bounds for provisioning capacity."
								properties: resources: {
									additionalProperties: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
										"x-kubernetes-int-or-string": true
									}
									description: "Resources contains all the allocatable resources that Karpenter supports for limiting."

									type: "object"
								}
								type: "object"
							}
							provider: {
								description:                            "Provider contains fields specific to your cloudprovider."
								type:                                   "object"
								"x-kubernetes-preserve-unknown-fields": true
							}
							providerRef: {
								description: "ProviderRef is a reference to a dedicated CRD for the chosen provider, that holds additional configuration options"

								properties: {
									apiVersion: {
										description: "API version of the referent"
										type:        "string"
									}
									kind: {
										description: "Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\""
										type:        "string"
									}
									name: {
										description: "Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names"
										type:        "string"
									}
								}
								required: ["name"]
								type: "object"
							}
							requirements: {
								description: "Requirements are layered with Labels and applied to every node."

								items: {
									description: "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

									properties: {
										key: {
											description: "The label key that the selector applies to."
											type:        "string"
										}
										operator: {
											description: "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."

											type: "string"
										}
										values: {
											description: "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."

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
							startupTaints: {
								description: "StartupTaints are taints that are applied to nodes upon startup which are expected to be removed automatically within a short period of time, typically by a DaemonSet that tolerates the taint. These are commonly used by daemonsets to allow initialization and enforce startup ordering.  StartupTaints are ignored for provisioning purposes in that pods are not required to tolerate a StartupTaint in order to have nodes provisioned for them."

								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
							taints: {
								description: "Taints will be applied to every node launched by the Provisioner. If specified, the provisioner will not provision nodes for pods that do not have matching tolerations. Additional taints will be created that match pod tolerations on a per-node basis."

								items: {
									description: "The node this Taint is attached to has the \"effect\" on any pod that does not tolerate the Taint."

									properties: {
										effect: {
											description: "Required. The effect of the taint on pods that do not tolerate the taint. Valid effects are NoSchedule, PreferNoSchedule and NoExecute."

											type: "string"
										}
										key: {
											description: "Required. The taint key to be applied to a node."
											type:        "string"
										}
										timeAdded: {
											description: "TimeAdded represents the time at which the taint was added. It is only written for NoExecute taints."

											format: "date-time"
											type:   "string"
										}
										value: {
											description: "The taint value corresponding to the taint key."
											type:        "string"
										}
									}
									required: [
										"effect",
										"key",
									]
									type: "object"
								}
								type: "array"
							}
							ttlSecondsAfterEmpty: {
								description: """
		TTLSecondsAfterEmpty is the number of seconds the controller will wait before attempting to delete a node, measured from when the node is detected to be empty. A Node is considered to be empty when it does not have pods scheduled to it, excluding daemonsets. 
		 Termination due to no utilization is disabled if this field is not set.
		"""

								format: "int64"
								type:   "integer"
							}
							ttlSecondsUntilExpired: {
								description: """
		TTLSecondsUntilExpired is the number of seconds the controller will wait before terminating a node, measured from when the node is created. This is useful to implement features like eventually consistent node upgrade, memory leak protection, and disruption testing. 
		 Termination due to expiration is disabled if this field is not set.
		"""

								format: "int64"
								type:   "integer"
							}
							weight: {
								description: "Weight is the priority given to the provisioner during scheduling. A higher numerical weight indicates that this provisioner will be ordered ahead of other provisioners with lower weights. A provisioner with no weight will be treated as if it is a provisioner with a weight of 0."

								format:  "int32"
								maximum: 100
								minimum: 1
								type:    "integer"
							}
						}
						type: "object"
					}
					status: {
						description: "ProvisionerStatus defines the observed state of Provisioner"
						properties: {
							conditions: {
								description: "Conditions is the set of conditions required for this provisioner to scale its target, and indicates whether or not those conditions are met."

								items: {
									description: "Condition defines a readiness condition for a Knative resource. See: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#typical-status-properties"

									properties: {
										lastTransitionTime: {
											description: "LastTransitionTime is the last time the condition transitioned from one status to another. We use VolatileTime in place of metav1.Time to exclude this from creating equality.Semantic differences (all other things held constant)."

											type: "string"
										}
										message: {
											description: "A human readable message indicating details about the transition."

											type: "string"
										}
										reason: {
											description: "The reason for the condition's last transition."
											type:        "string"
										}
										severity: {
											description: "Severity with which to treat failures of this type of condition. When this is not specified, it defaults to Error."

											type: "string"
										}
										status: {
											description: "Status of the condition, one of True, False, Unknown."
											type:        "string"
										}
										type: {
											description: "Type of condition."
											type:        "string"
										}
									}
									required: [
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							lastScaleTime: {
								description: "LastScaleTime is the last time the Provisioner scaled the number of nodes"

								format: "date-time"
								type:   "string"
							}
							resources: {
								additionalProperties: {
									anyOf: [{
										type: "integer"
									}, {
										type: "string"
									}]
									pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
									"x-kubernetes-int-or-string": true
								}
								description: "Resources is the list of resources that have been provisioned."
								type:        "object"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
res: serviceaccount: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::510430971399:role/coder-amanibhavam-class-cluster"
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
}
res: role: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
	rules: [{
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: [
			"get",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"configmaps",
			"namespaces",
			"secrets",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resourceNames: ["karpenter-cert"]
		resources: ["secrets"]
		verbs: ["update"]
	}, {
		apiGroups: [""]
		resourceNames: [
			"karpenter-global-settings",
			"config-logging",
		]
		resources: ["configmaps"]
		verbs: [
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resourceNames: ["karpenter-leader-election"]
		resources: ["leases"]
		verbs: [
			"patch",
			"update",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resourceNames: [
			"webhook.configmapwebhook.00-of-01",
			"webhook.defaultingwebhook.00-of-01",
			"webhook.validationwebhook.00-of-01",
			"webhook.webhookcertificates.00-of-01",
		]
		resources: ["leases"]
		verbs: [
			"patch",
			"update",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: ["create"]
	}, {
		apiGroups: [""]
		resources: ["configmaps"]
		verbs: ["create"]
	}]
}
res: role: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-dns": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-dns"
		namespace: "karpenter"
	}
	rules: [{
		apiGroups: [""]
		resourceNames: ["kube-dns"]
		resources: ["services"]
		verbs: ["get"]
	}]
}
res: role: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-lease": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-lease"
		namespace: "karpenter"
	}
	rules: [{
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: ["delete"]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-karpenter": cluster: karpenter: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "karpenter"
	}
	rules: [{
		apiGroups: ["karpenter.k8s.aws"]
		resources: [
			"awsnodetemplates",
			"ec2nodeclasses",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["karpenter.k8s.aws"]
		resources: [
			"awsnodetemplates",
			"awsnodetemplates/status",
			"ec2nodeclasses",
			"ec2nodeclasses/status",
		]
		verbs: [
			"patch",
			"update",
		]
	}, {
		apiGroups: ["admissionregistration.k8s.io"]
		resourceNames: ["validation.webhook.karpenter.k8s.aws"]
		resources: ["validatingwebhookconfigurations"]
		verbs: ["update"]
	}, {
		apiGroups: ["admissionregistration.k8s.io"]
		resourceNames: ["defaulting.webhook.karpenter.k8s.aws"]
		resources: ["mutatingwebhookconfigurations"]
		verbs: ["update"]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-admin": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":                   "karpenter"
			"app.kubernetes.io/managed-by":                 "Helm"
			"app.kubernetes.io/name":                       "karpenter"
			"app.kubernetes.io/version":                    "0.32.4"
			"helm.sh/chart":                                "karpenter-v0.32.4"
			"rbac.authorization.k8s.io/aggregate-to-admin": "true"
		}
		name: "karpenter-admin"
	}
	rules: [{
		apiGroups: ["karpenter.sh"]
		resources: [
			"provisioners",
			"provisioners/status",
			"machines",
			"machines/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"delete",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"nodepools",
			"nodepools/status",
			"nodeclaims",
			"nodeclaims/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"delete",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.k8s.aws"]
		resources: ["awsnodetemplates"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"delete",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.k8s.aws"]
		resources: ["ec2nodeclasses"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"delete",
			"patch",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-core": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "karpenter-core"
	}
	rules: [{
		apiGroups: ["karpenter.sh"]
		resources: [
			"provisioners",
			"provisioners/status",
			"machines",
			"machines/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"nodepools",
			"nodepools/status",
			"nodeclaims",
			"nodeclaims/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [""]
		resources: [
			"pods",
			"nodes",
			"persistentvolumes",
			"persistentvolumeclaims",
			"replicationcontrollers",
			"namespaces",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["storage.k8s.io"]
		resources: [
			"storageclasses",
			"csinodes",
		]
		verbs: [
			"get",
			"watch",
			"list",
		]
	}, {
		apiGroups: ["apps"]
		resources: [
			"daemonsets",
			"deployments",
			"replicasets",
			"statefulsets",
		]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: ["admissionregistration.k8s.io"]
		resources: [
			"validatingwebhookconfigurations",
			"mutatingwebhookconfigurations",
		]
		verbs: [
			"get",
			"watch",
			"list",
		]
	}, {
		apiGroups: ["policy"]
		resources: ["poddisruptionbudgets"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"machines",
			"machines/status",
		]
		verbs: [
			"create",
			"delete",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"provisioners",
			"provisioners/status",
		]
		verbs: [
			"update",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"nodeclaims",
			"nodeclaims/status",
		]
		verbs: [
			"create",
			"delete",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["karpenter.sh"]
		resources: [
			"nodepools",
			"nodepools/status",
		]
		verbs: [
			"update",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: [
			"create",
			"patch",
		]
	}, {
		apiGroups: [""]
		resources: ["nodes"]
		verbs: [
			"create",
			"patch",
			"delete",
		]
	}, {
		apiGroups: [""]
		resources: ["pods/eviction"]
		verbs: ["create"]
	}, {
		apiGroups: ["admissionregistration.k8s.io"]
		resourceNames: [
			"validation.webhook.karpenter.sh",
			"validation.webhook.config.karpenter.sh",
		]
		resources: ["validatingwebhookconfigurations"]
		verbs: ["update"]
	}]
}
res: rolebinding: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "karpenter"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: rolebinding: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-dns": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-dns"
		namespace: "karpenter"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "karpenter-dns"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: rolebinding: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-lease": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-lease"
		namespace: "karpenter"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "karpenter-lease"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-karpenter": cluster: karpenter: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "karpenter"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "karpenter"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-admin": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "karpenter-admin"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-boot-strapper": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "karpenter-boot-strapper"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "system:boot-strapper"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-core": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "karpenter-core"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "karpenter-core"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-karpenter": cluster: "karpenter-node": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "karpenter-node"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "system:node"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "karpenter"
		namespace: "karpenter"
	}]
}
res: configmap: "coder-amanibhavam-class-cluster-karpenter": karpenter: "config-logging": {
	apiVersion: "v1"
	data: {
		"loglevel.controller": "debug"
		"loglevel.webhook":    "error"
		"zap-logger-config": """
			{
			  \"level\": \"debug\",
			  \"development\": false,
			  \"disableStacktrace\": true,
			  \"disableCaller\": true,
			  \"sampling\": {
			    \"initial\": 100,
			    \"thereafter\": 100
			  },
			  \"outputPaths\": [\"stdout\"],
			  \"errorOutputPaths\": [\"stderr\"],
			  \"encoding\": \"json\",
			  \"encoderConfig\": {
			    \"timeKey\": \"time\",
			    \"levelKey\": \"level\",
			    \"nameKey\": \"logger\",
			    \"callerKey\": \"caller\",
			    \"messageKey\": \"message\",
			    \"stacktraceKey\": \"stacktrace\",
			    \"levelEncoder\": \"capital\",
			    \"timeEncoder\": \"iso8601\"
			  }
			}

			"""
	}

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "config-logging"
		namespace: "karpenter"
	}
}
res: configmap: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-global-settings": {
	apiVersion: "v1"
	data: {
		"aws.clusterEndpoint": "https://kubernetes.default.svc.cluster.local:443"
		"aws.clusterName":     "coder-amanibhavam-class"
		batchIdleDuration:     "1s"
		batchMaxDuration:      "10s"
	}
	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-global-settings"
		namespace: "karpenter"
	}
}
res: secret: "coder-amanibhavam-class-cluster-karpenter": karpenter: "karpenter-cert": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter-cert"
		namespace: "karpenter"
	}
}
res: service: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
	spec: {
		ports: [{
			name:       "http-metrics"
			port:       8000
			protocol:   "TCP"
			targetPort: "http-metrics"
		}, {
			name:       "webhook-metrics"
			port:       8001
			protocol:   "TCP"
			targetPort: "webhook-metrics"
		}, {
			name:       "https-webhook"
			port:       8443
			protocol:   "TCP"
			targetPort: "https-webhook"
		}]
		selector: {
			"app.kubernetes.io/instance": "karpenter"
			"app.kubernetes.io/name":     "karpenter"
		}
		type: "ClusterIP"
	}
}
res: deployment: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
	spec: {
		replicas:             1
		revisionHistoryLimit: 10
		selector: matchLabels: {
			"app.kubernetes.io/instance": "karpenter"
			"app.kubernetes.io/name":     "karpenter"
		}
		strategy: rollingUpdate: maxUnavailable: 1
		template: {
			metadata: {
				annotations: "checksum/settings": "fe3ae391dc54d2557d6bf7de2223e2345938037d2fcbe256a87d5ce45a40391a"
				labels: {
					"app.kubernetes.io/instance": "karpenter"
					"app.kubernetes.io/name":     "karpenter"
				}
			}
			spec: {
				affinity: {
					nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
						matchExpressions: [{
							key:      "karpenter.sh/provisioner-name"
							operator: "DoesNotExist"
						}, {
							key:      "karpenter.sh/nodepool"
							operator: "DoesNotExist"
						}]
					}]
					podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
						labelSelector: matchLabels: {
							"app.kubernetes.io/instance": "karpenter"
							"app.kubernetes.io/name":     "karpenter"
						}
						topologyKey: "kubernetes.io/hostname"
					}]
				}
				containers: [{
					env: [{
						name:  "KUBERNETES_MIN_VERSION"
						value: "1.19.0-0"
					}, {
						name:  "KARPENTER_SERVICE"
						value: "karpenter"
					}, {
						name:  "WEBHOOK_PORT"
						value: "8443"
					}, {
						name:  "WEBHOOK_METRICS_PORT"
						value: "8001"
					}, {
						name:  "LOG_LEVEL"
						value: "debug"
					}, {
						name:  "METRICS_PORT"
						value: "8000"
					}, {
						name:  "HEALTH_PROBE_PORT"
						value: "8081"
					}, {
						name: "SYSTEM_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name: "MEMORY_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "controller"
							divisor:       "0"
							resource:      "limits.memory"
						}
					}, {
						name:  "FEATURE_GATES"
						value: "Drift=false"
					}, {
						name:  "BATCH_MAX_DURATION"
						value: "10s"
					}, {
						name:  "BATCH_IDLE_DURATION"
						value: "1s"
					}, {
						name:  "ASSUME_ROLE_DURATION"
						value: "15m"
					}, {
						name:  "VM_MEMORY_OVERHEAD_PERCENT"
						value: "0.075"
					}, {
						name:  "RESERVED_ENIS"
						value: "0"
					}, {
						name:  "AWS_REGION"
						value: "us-west-2"
					}]
					image:           "public.ecr.aws/karpenter/controller:v0.32.4@sha256:df145069be18291dd656e61b526625424bffc064bdc67109796d6256e3d2397b"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						httpGet: {
							path: "/healthz"
							port: "http"
						}
						initialDelaySeconds: 30
						timeoutSeconds:      30
					}
					name: "controller"
					ports: [{
						containerPort: 8000
						name:          "http-metrics"
						protocol:      "TCP"
					}, {
						containerPort: 8001
						name:          "webhook-metrics"
						protocol:      "TCP"
					}, {
						containerPort: 8443
						name:          "https-webhook"
						protocol:      "TCP"
					}, {
						containerPort: 8081
						name:          "http"
						protocol:      "TCP"
					}]
					readinessProbe: {
						httpGet: {
							path: "/readyz"
							port: "http"
						}
						initialDelaySeconds: 5
						timeoutSeconds:      30
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsGroup:             65536
						runAsNonRoot:           true
						runAsUser:              65536
						seccompProfile: type: "RuntimeDefault"
					}
					volumeMounts: [{
						mountPath: "/etc/karpenter/logging"
						name:      "config-logging"
					}]
				}]
				dnsPolicy: "Default"
				nodeSelector: "kubernetes.io/os": "linux"
				priorityClassName:  "system-cluster-critical"
				serviceAccountName: "karpenter"
				tolerations: [{
					key:      "CriticalAddonsOnly"
					operator: "Exists"
				}]
				topologySpreadConstraints: [{
					labelSelector: matchLabels: {
						"app.kubernetes.io/instance": "karpenter"
						"app.kubernetes.io/name":     "karpenter"
					}
					maxSkew:           1
					topologyKey:       "topology.kubernetes.io/zone"
					whenUnsatisfiable: "ScheduleAnyway"
				}]
				volumes: [{
					configMap: name: "config-logging"
					name: "config-logging"
				}]
			}
		}
	}
}
res: poddisruptionbudget: "coder-amanibhavam-class-cluster-karpenter": karpenter: karpenter: {
	apiVersion: "policy/v1"
	kind:       "PodDisruptionBudget"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name:      "karpenter"
		namespace: "karpenter"
	}
	spec: {
		maxUnavailable: 1
		selector: matchLabels: {
			"app.kubernetes.io/instance": "karpenter"
			"app.kubernetes.io/name":     "karpenter"
		}
	}
}
res: awsnodetemplate: "coder-amanibhavam-class-cluster-karpenter": karpenter: default: {
	apiVersion: "karpenter.k8s.aws/v1alpha1"
	kind:       "AWSNodeTemplate"
	metadata: {
		name:      "default"
		namespace: "karpenter"
	}
	spec: {
		amiFamily: "Custom"
		amiSelector: "karpenter.sh/discovery": "coder-amanibhavam-class"
		blockDeviceMappings: [{
			deviceName: "/dev/sda1"
			ebs: {
				deleteOnTermination: true
				encrypted:           true
				volumeSize:          "40Gi"
				volumeType:          "gp3"
			}
		}]
		instanceProfile: "coder-amanibhavam-class"
		securityGroupSelector: "karpenter.sh/discovery": "coder-amanibhavam-class"
		subnetSelector: "karpenter.sh/discovery": "coder-amanibhavam-class"
		userData: """
			MIME-Version: 1.0
			Content-Type: multipart/mixed; boundary=\"BOUNDARY\"
			--BOUNDARY
			Content-Type: text/x-shellscript; charset=\"us-ascii\"
			#!/bin/bash

			set -efu

			cat | sudo -u ubuntu bash <<'EOF'
			cd
			source .bash_profile

			cluster_name=coder-amanibhavam-class
			sudo $(which tailscale) up --auth-key \"$(cd m/pkg/chamber && nix develop --command chamber -b secretsmanager read --quiet ${cluster_name} tailscale_authkey)\"

			ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
			cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

			TOKEN=\"$(curl -sSL -X PUT \"http://169.254.169.254/latest/api/token\" -H \"X-aws-ec2-metadata-token-ttl-seconds: 21600\")\"
			instance=\"$(curl -sSL -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id)\"
			az=\"$(curl -sSL -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)\"
			container_ip=\"$(curl -sSL -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/local-ipv4)\"

			(cd m/pkg/k3sup && nix develop --command k3sup join --user ubuntu --server-host ${cluster_name} --server-user ubuntu --k3s-extra-args \"--kubelet-arg provider-id=aws:///${az}/${instance} --node-ip ${container_ip}\")
			EOF

			--BOUNDARY

			"""
	}
}
res: provisioner: "coder-amanibhavam-class-cluster-karpenter": karpenter: default: {
	apiVersion: "karpenter.sh/v1alpha5"
	kind:       "Provisioner"
	metadata: {
		name:      "default"
		namespace: "karpenter"
	}
	spec: {
		consolidation: enabled: true
		limits: resources: cpu: "8"
		providerRef: name: "default"
		requirements: [{
			key:      "karpenter.sh/capacity-type"
			operator: "In"
			values: ["spot"]
		}, {
			key:      "kubernetes.io/os"
			operator: "In"
			values: ["linux"]
		}, {
			key:      "kubernetes.io/arch"
			operator: "In"
			values: ["amd64"]
		}, {
			key:      "karpenter.k8s.aws/instance-category"
			operator: "In"
			values: [
				"c",
				"m",
				"r",
			]
		}, {
			key:      "karpenter.k8s.aws/instance-generation"
			operator: "Gt"
			values: ["2"]
		}]
		startupTaints: [{
			effect: "NoExecute"
			key:    "node.cilium.io/agent-not-ready"
			value:  "true"
		}]
	}
}
res: mutatingwebhookconfiguration: "coder-amanibhavam-class-cluster-karpenter": cluster: "defaulting.webhook.karpenter.k8s.aws": {
	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "MutatingWebhookConfiguration"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "defaulting.webhook.karpenter.k8s.aws"
	}
	webhooks: [{
		admissionReviewVersions: ["v1"]
		clientConfig: service: {
			name:      "karpenter"
			namespace: "karpenter"
			port:      8443
		}
		failurePolicy: "Fail"
		name:          "defaulting.webhook.karpenter.k8s.aws"
		rules: [{
			apiGroups: ["karpenter.k8s.aws"]
			apiVersions: ["v1alpha1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"awsnodetemplates",
				"awsnodetemplates/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.k8s.aws"]
			apiVersions: ["v1beta1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"ec2nodeclasses",
				"ec2nodeclasses/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.sh"]
			apiVersions: ["v1alpha5"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"provisioners",
				"provisioners/status",
			]
			scope: "*"
		}]
		sideEffects: "None"
	}]
}
res: validatingwebhookconfiguration: "coder-amanibhavam-class-cluster-karpenter": cluster: "validation.webhook.config.karpenter.sh": {
	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "ValidatingWebhookConfiguration"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "validation.webhook.config.karpenter.sh"
	}
	webhooks: [{
		admissionReviewVersions: ["v1"]
		clientConfig: service: {
			name:      "karpenter"
			namespace: "karpenter"
			port:      8443
		}
		failurePolicy: "Fail"
		name:          "validation.webhook.config.karpenter.sh"
		objectSelector: matchLabels: "app.kubernetes.io/part-of": "karpenter"
		sideEffects: "None"
	}]
}
res: validatingwebhookconfiguration: "coder-amanibhavam-class-cluster-karpenter": cluster: "validation.webhook.karpenter.k8s.aws": {
	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "ValidatingWebhookConfiguration"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "validation.webhook.karpenter.k8s.aws"
	}
	webhooks: [{
		admissionReviewVersions: ["v1"]
		clientConfig: service: {
			name:      "karpenter"
			namespace: "karpenter"
			port:      8443
		}
		failurePolicy: "Fail"
		name:          "validation.webhook.karpenter.k8s.aws"
		rules: [{
			apiGroups: ["karpenter.k8s.aws"]
			apiVersions: ["v1alpha1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"awsnodetemplates",
				"awsnodetemplates/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.k8s.aws"]
			apiVersions: ["v1beta1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"ec2nodeclasses",
				"ec2nodeclasses/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.sh"]
			apiVersions: ["v1alpha5"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"provisioners",
				"provisioners/status",
			]
			scope: "*"
		}]
		sideEffects: "None"
	}]
}
res: validatingwebhookconfiguration: "coder-amanibhavam-class-cluster-karpenter": cluster: "validation.webhook.karpenter.sh": {
	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "ValidatingWebhookConfiguration"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "karpenter"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "karpenter"
			"app.kubernetes.io/version":    "0.32.4"
			"helm.sh/chart":                "karpenter-v0.32.4"
		}
		name: "validation.webhook.karpenter.sh"
	}
	webhooks: [{
		admissionReviewVersions: ["v1"]
		clientConfig: service: {
			name:      "karpenter"
			namespace: "karpenter"
			port:      8443
		}
		failurePolicy: "Fail"
		name:          "validation.webhook.karpenter.sh"
		rules: [{
			apiGroups: ["karpenter.sh"]
			apiVersions: ["v1alpha5"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"provisioners",
				"provisioners/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.sh"]
			apiVersions: ["v1beta1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"nodeclaims",
				"nodeclaims/status",
			]
			scope: "*"
		}, {
			apiGroups: ["karpenter.sh"]
			apiVersions: ["v1beta1"]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"nodepools",
				"nodepools/status",
			]
			scope: "*"
		}]
		sideEffects: "None"
	}]
}
