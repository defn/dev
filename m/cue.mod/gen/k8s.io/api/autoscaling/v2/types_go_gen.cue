// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/autoscaling/v2

package v2

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/resource"
)

// HorizontalPodAutoscaler is the configuration for a horizontal pod
// autoscaler, which automatically manages the replica count of any resource
// implementing the scale subresource based on the metrics specified.
#HorizontalPodAutoscaler: {
	metav1.#TypeMeta

	// metadata is the standard object metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// spec is the specification for the behaviour of the autoscaler.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status.
	// +optional
	spec?: #HorizontalPodAutoscalerSpec @go(Spec) @protobuf(2,bytes,opt)

	// status is the current information about the autoscaler.
	// +optional
	status?: #HorizontalPodAutoscalerStatus @go(Status) @protobuf(3,bytes,opt)
}

// HorizontalPodAutoscalerSpec describes the desired functionality of the HorizontalPodAutoscaler.
#HorizontalPodAutoscalerSpec: {
	// scaleTargetRef points to the target resource to scale, and is used to the pods for which metrics
	// should be collected, as well as to actually change the replica count.
	scaleTargetRef: #CrossVersionObjectReference @go(ScaleTargetRef) @protobuf(1,bytes,opt)

	// minReplicas is the lower limit for the number of replicas to which the autoscaler
	// can scale down.  It defaults to 1 pod.  minReplicas is allowed to be 0 if the
	// alpha feature gate HPAScaleToZero is enabled and at least one Object or External
	// metric is configured.  Scaling is active as long as at least one metric value is
	// available.
	// +optional
	minReplicas?: null | int32 @go(MinReplicas,*int32) @protobuf(2,varint,opt)

	// maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up.
	// It cannot be less that minReplicas.
	maxReplicas: int32 @go(MaxReplicas) @protobuf(3,varint,opt)

	// metrics contains the specifications for which to use to calculate the
	// desired replica count (the maximum replica count across all metrics will
	// be used).  The desired replica count is calculated multiplying the
	// ratio between the target value and the current value by the current
	// number of pods.  Ergo, metrics used must decrease as the pod count is
	// increased, and vice-versa.  See the individual metric source types for
	// more information about how each type of metric must respond.
	// If not set, the default metric will be set to 80% average CPU utilization.
	// +listType=atomic
	// +optional
	metrics?: [...#MetricSpec] @go(Metrics,[]MetricSpec) @protobuf(4,bytes,rep)

	// behavior configures the scaling behavior of the target
	// in both Up and Down directions (scaleUp and scaleDown fields respectively).
	// If not set, the default HPAScalingRules for scale up and scale down are used.
	// +optional
	behavior?: null | #HorizontalPodAutoscalerBehavior @go(Behavior,*HorizontalPodAutoscalerBehavior) @protobuf(5,bytes,opt)
}

// CrossVersionObjectReference contains enough information to let you identify the referred resource.
#CrossVersionObjectReference: {
	// kind is the kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: string @go(Kind) @protobuf(1,bytes,opt)

	// name is the name of the referent; More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
	name: string @go(Name) @protobuf(2,bytes,opt)

	// apiVersion is the API version of the referent
	// +optional
	apiVersion?: string @go(APIVersion) @protobuf(3,bytes,opt)
}

// MetricSpec specifies how to scale based on a single metric
// (only `type` and one other matching field should be set at once).
#MetricSpec: {
	// type is the type of metric source.  It should be one of "ContainerResource", "External",
	// "Object", "Pods" or "Resource", each mapping to a matching field in the object.
	// Note: "ContainerResource" type is available on when the feature-gate
	// HPAContainerMetrics is enabled
	type: #MetricSourceType @go(Type) @protobuf(1,bytes)

	// object refers to a metric describing a single kubernetes object
	// (for example, hits-per-second on an Ingress object).
	// +optional
	object?: null | #ObjectMetricSource @go(Object,*ObjectMetricSource) @protobuf(2,bytes,opt)

	// pods refers to a metric describing each pod in the current scale target
	// (for example, transactions-processed-per-second).  The values will be
	// averaged together before being compared to the target value.
	// +optional
	pods?: null | #PodsMetricSource @go(Pods,*PodsMetricSource) @protobuf(3,bytes,opt)

	// resource refers to a resource metric (such as those specified in
	// requests and limits) known to Kubernetes describing each pod in the
	// current scale target (e.g. CPU or memory). Such metrics are built in to
	// Kubernetes, and have special scaling options on top of those available
	// to normal per-pod metrics using the "pods" source.
	// +optional
	resource?: null | #ResourceMetricSource @go(Resource,*ResourceMetricSource) @protobuf(4,bytes,opt)

	// containerResource refers to a resource metric (such as those specified in
	// requests and limits) known to Kubernetes describing a single container in
	// each pod of the current scale target (e.g. CPU or memory). Such metrics are
	// built in to Kubernetes, and have special scaling options on top of those
	// available to normal per-pod metrics using the "pods" source.
	// This is an alpha feature and can be enabled by the HPAContainerMetrics feature flag.
	// +optional
	containerResource?: null | #ContainerResourceMetricSource @go(ContainerResource,*ContainerResourceMetricSource) @protobuf(7,bytes,opt)

	// external refers to a global metric that is not associated
	// with any Kubernetes object. It allows autoscaling based on information
	// coming from components running outside of cluster
	// (for example length of queue in cloud messaging service, or
	// QPS from loadbalancer running outside of cluster).
	// +optional
	external?: null | #ExternalMetricSource @go(External,*ExternalMetricSource) @protobuf(5,bytes,opt)
}

// HorizontalPodAutoscalerBehavior configures the scaling behavior of the target
// in both Up and Down directions (scaleUp and scaleDown fields respectively).
#HorizontalPodAutoscalerBehavior: {
	// scaleUp is scaling policy for scaling Up.
	// If not set, the default value is the higher of:
	//   * increase no more than 4 pods per 60 seconds
	//   * double the number of pods per 60 seconds
	// No stabilization is used.
	// +optional
	scaleUp?: null | #HPAScalingRules @go(ScaleUp,*HPAScalingRules) @protobuf(1,bytes,opt)

	// scaleDown is scaling policy for scaling Down.
	// If not set, the default value is to allow to scale down to minReplicas pods, with a
	// 300 second stabilization window (i.e., the highest recommendation for
	// the last 300sec is used).
	// +optional
	scaleDown?: null | #HPAScalingRules @go(ScaleDown,*HPAScalingRules) @protobuf(2,bytes,opt)
}

// ScalingPolicySelect is used to specify which policy should be used while scaling in a certain direction
#ScalingPolicySelect: string // #enumScalingPolicySelect

#enumScalingPolicySelect:
	#MaxChangePolicySelect |
	#MinChangePolicySelect |
	#DisabledPolicySelect

// MaxChangePolicySelect  selects the policy with the highest possible change.
#MaxChangePolicySelect: #ScalingPolicySelect & "Max"

// MinChangePolicySelect selects the policy with the lowest possible change.
#MinChangePolicySelect: #ScalingPolicySelect & "Min"

// DisabledPolicySelect disables the scaling in this direction.
#DisabledPolicySelect: #ScalingPolicySelect & "Disabled"

// HPAScalingRules configures the scaling behavior for one direction.
// These Rules are applied after calculating DesiredReplicas from metrics for the HPA.
// They can limit the scaling velocity by specifying scaling policies.
// They can prevent flapping by specifying the stabilization window, so that the
// number of replicas is not set instantly, instead, the safest value from the stabilization
// window is chosen.
#HPAScalingRules: {
	// stabilizationWindowSeconds is the number of seconds for which past recommendations should be
	// considered while scaling up or scaling down.
	// StabilizationWindowSeconds must be greater than or equal to zero and less than or equal to 3600 (one hour).
	// If not set, use the default values:
	// - For scale up: 0 (i.e. no stabilization is done).
	// - For scale down: 300 (i.e. the stabilization window is 300 seconds long).
	// +optional
	stabilizationWindowSeconds?: null | int32 @go(StabilizationWindowSeconds,*int32) @protobuf(3,varint,opt)

	// selectPolicy is used to specify which policy should be used.
	// If not set, the default value Max is used.
	// +optional
	selectPolicy?: null | #ScalingPolicySelect @go(SelectPolicy,*ScalingPolicySelect) @protobuf(1,bytes,opt)

	// policies is a list of potential scaling polices which can be used during scaling.
	// At least one policy must be specified, otherwise the HPAScalingRules will be discarded as invalid
	// +listType=atomic
	// +optional
	policies?: [...#HPAScalingPolicy] @go(Policies,[]HPAScalingPolicy) @protobuf(2,bytes,rep)
}

// HPAScalingPolicyType is the type of the policy which could be used while making scaling decisions.
#HPAScalingPolicyType: string // #enumHPAScalingPolicyType

#enumHPAScalingPolicyType:
	#PodsScalingPolicy |
	#PercentScalingPolicy

// PodsScalingPolicy is a policy used to specify a change in absolute number of pods.
#PodsScalingPolicy: #HPAScalingPolicyType & "Pods"

// PercentScalingPolicy is a policy used to specify a relative amount of change with respect to
// the current number of pods.
#PercentScalingPolicy: #HPAScalingPolicyType & "Percent"

// HPAScalingPolicy is a single policy which must hold true for a specified past interval.
#HPAScalingPolicy: {
	// type is used to specify the scaling policy.
	type: #HPAScalingPolicyType @go(Type) @protobuf(1,bytes,opt,casttype=HPAScalingPolicyType)

	// value contains the amount of change which is permitted by the policy.
	// It must be greater than zero
	value: int32 @go(Value) @protobuf(2,varint,opt)

	// periodSeconds specifies the window of time for which the policy should hold true.
	// PeriodSeconds must be greater than zero and less than or equal to 1800 (30 min).
	periodSeconds: int32 @go(PeriodSeconds) @protobuf(3,varint,opt)
}

// MetricSourceType indicates the type of metric.
#MetricSourceType: string // #enumMetricSourceType

#enumMetricSourceType:
	#ObjectMetricSourceType |
	#PodsMetricSourceType |
	#ResourceMetricSourceType |
	#ContainerResourceMetricSourceType |
	#ExternalMetricSourceType

// ObjectMetricSourceType is a metric describing a kubernetes object
// (for example, hits-per-second on an Ingress object).
#ObjectMetricSourceType: #MetricSourceType & "Object"

// PodsMetricSourceType is a metric describing each pod in the current scale
// target (for example, transactions-processed-per-second).  The values
// will be averaged together before being compared to the target value.
#PodsMetricSourceType: #MetricSourceType & "Pods"

// ResourceMetricSourceType is a resource metric known to Kubernetes, as
// specified in requests and limits, describing each pod in the current
// scale target (e.g. CPU or memory).  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available
// to normal per-pod metrics (the "pods" source).
#ResourceMetricSourceType: #MetricSourceType & "Resource"

// ContainerResourceMetricSourceType is a resource metric known to Kubernetes, as
// specified in requests and limits, describing a single container in each pod in the current
// scale target (e.g. CPU or memory).  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available
// to normal per-pod metrics (the "pods" source).
#ContainerResourceMetricSourceType: #MetricSourceType & "ContainerResource"

// ExternalMetricSourceType is a global metric that is not associated
// with any Kubernetes object. It allows autoscaling based on information
// coming from components running outside of cluster
// (for example length of queue in cloud messaging service, or
// QPS from loadbalancer running outside of cluster).
#ExternalMetricSourceType: #MetricSourceType & "External"

// ObjectMetricSource indicates how to scale on a metric describing a
// kubernetes object (for example, hits-per-second on an Ingress object).
#ObjectMetricSource: {
	// describedObject specifies the descriptions of a object,such as kind,name apiVersion
	describedObject: #CrossVersionObjectReference @go(DescribedObject) @protobuf(1,bytes)

	// target specifies the target value for the given metric
	target: #MetricTarget @go(Target) @protobuf(2,bytes)

	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(3,bytes)
}

// PodsMetricSource indicates how to scale on a metric describing each pod in
// the current scale target (for example, transactions-processed-per-second).
// The values will be averaged together before being compared to the target
// value.
#PodsMetricSource: {
	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(1,bytes)

	// target specifies the target value for the given metric
	target: #MetricTarget @go(Target) @protobuf(2,bytes)
}

// ResourceMetricSource indicates how to scale on a resource metric known to
// Kubernetes, as specified in requests and limits, describing each pod in the
// current scale target (e.g. CPU or memory).  The values will be averaged
// together before being compared to the target.  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available to
// normal per-pod metrics using the "pods" source.  Only one "target" type
// should be set.
#ResourceMetricSource: {
	// name is the name of the resource in question.
	name: v1.#ResourceName @go(Name) @protobuf(1,bytes)

	// target specifies the target value for the given metric
	target: #MetricTarget @go(Target) @protobuf(2,bytes)
}

// ContainerResourceMetricSource indicates how to scale on a resource metric known to
// Kubernetes, as specified in requests and limits, describing each pod in the
// current scale target (e.g. CPU or memory).  The values will be averaged
// together before being compared to the target.  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available to
// normal per-pod metrics using the "pods" source.  Only one "target" type
// should be set.
#ContainerResourceMetricSource: {
	// name is the name of the resource in question.
	name: v1.#ResourceName @go(Name) @protobuf(1,bytes)

	// target specifies the target value for the given metric
	target: #MetricTarget @go(Target) @protobuf(2,bytes)

	// container is the name of the container in the pods of the scaling target
	container: string @go(Container) @protobuf(3,bytes,opt)
}

// ExternalMetricSource indicates how to scale on a metric not associated with
// any Kubernetes object (for example length of queue in cloud
// messaging service, or QPS from loadbalancer running outside of cluster).
#ExternalMetricSource: {
	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(1,bytes)

	// target specifies the target value for the given metric
	target: #MetricTarget @go(Target) @protobuf(2,bytes)
}

// MetricIdentifier defines the name and optionally selector for a metric
#MetricIdentifier: {
	// name is the name of the given metric
	name: string @go(Name) @protobuf(1,bytes)

	// selector is the string-encoded form of a standard kubernetes label selector for the given metric
	// When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping.
	// When unset, just the metricName will be used to gather metrics.
	// +optional
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(2,bytes)
}

// MetricTarget defines the target value, average value, or average utilization of a specific metric
#MetricTarget: {
	// type represents whether the metric type is Utilization, Value, or AverageValue
	type: #MetricTargetType @go(Type) @protobuf(1,bytes)

	// value is the target value of the metric (as a quantity).
	// +optional
	value?: null | resource.#Quantity @go(Value,*resource.Quantity) @protobuf(2,bytes,opt)

	// averageValue is the target value of the average of the
	// metric across all relevant pods (as a quantity)
	// +optional
	averageValue?: null | resource.#Quantity @go(AverageValue,*resource.Quantity) @protobuf(3,bytes,opt)

	// averageUtilization is the target value of the average of the
	// resource metric across all relevant pods, represented as a percentage of
	// the requested value of the resource for the pods.
	// Currently only valid for Resource metric source type
	// +optional
	averageUtilization?: null | int32 @go(AverageUtilization,*int32) @protobuf(4,bytes,opt)
}

// MetricTargetType specifies the type of metric being targeted, and should be either
// "Value", "AverageValue", or "Utilization"
#MetricTargetType: string // #enumMetricTargetType

#enumMetricTargetType:
	#UtilizationMetricType |
	#ValueMetricType |
	#AverageValueMetricType

// UtilizationMetricType declares a MetricTarget is an AverageUtilization value
#UtilizationMetricType: #MetricTargetType & "Utilization"

// ValueMetricType declares a MetricTarget is a raw value
#ValueMetricType: #MetricTargetType & "Value"

// AverageValueMetricType declares a MetricTarget is an
#AverageValueMetricType: #MetricTargetType & "AverageValue"

// HorizontalPodAutoscalerStatus describes the current status of a horizontal pod autoscaler.
#HorizontalPodAutoscalerStatus: {
	// observedGeneration is the most recent generation observed by this autoscaler.
	// +optional
	observedGeneration?: null | int64 @go(ObservedGeneration,*int64) @protobuf(1,varint,opt)

	// lastScaleTime is the last time the HorizontalPodAutoscaler scaled the number of pods,
	// used by the autoscaler to control how often the number of pods is changed.
	// +optional
	lastScaleTime?: null | metav1.#Time @go(LastScaleTime,*metav1.Time) @protobuf(2,bytes,opt)

	// currentReplicas is current number of replicas of pods managed by this autoscaler,
	// as last seen by the autoscaler.
	// +optional
	currentReplicas?: int32 @go(CurrentReplicas) @protobuf(3,varint,opt)

	// desiredReplicas is the desired number of replicas of pods managed by this autoscaler,
	// as last calculated by the autoscaler.
	desiredReplicas: int32 @go(DesiredReplicas) @protobuf(4,varint,opt)

	// currentMetrics is the last read state of the metrics used by this autoscaler.
	// +listType=atomic
	// +optional
	currentMetrics: [...#MetricStatus] @go(CurrentMetrics,[]MetricStatus) @protobuf(5,bytes,rep)

	// conditions is the set of conditions required for this autoscaler to scale its target,
	// and indicates whether or not those conditions are met.
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	// +optional
	conditions?: [...#HorizontalPodAutoscalerCondition] @go(Conditions,[]HorizontalPodAutoscalerCondition) @protobuf(6,bytes,rep)
}

// HorizontalPodAutoscalerConditionType are the valid conditions of
// a HorizontalPodAutoscaler.
#HorizontalPodAutoscalerConditionType: string // #enumHorizontalPodAutoscalerConditionType

#enumHorizontalPodAutoscalerConditionType:
	#ScalingActive |
	#AbleToScale |
	#ScalingLimited

// ScalingActive indicates that the HPA controller is able to scale if necessary:
// it's correctly configured, can fetch the desired metrics, and isn't disabled.
#ScalingActive: #HorizontalPodAutoscalerConditionType & "ScalingActive"

// AbleToScale indicates a lack of transient issues which prevent scaling from occurring,
// such as being in a backoff window, or being unable to access/update the target scale.
#AbleToScale: #HorizontalPodAutoscalerConditionType & "AbleToScale"

// ScalingLimited indicates that the calculated scale based on metrics would be above or
// below the range for the HPA, and has thus been capped.
#ScalingLimited: #HorizontalPodAutoscalerConditionType & "ScalingLimited"

// HorizontalPodAutoscalerCondition describes the state of
// a HorizontalPodAutoscaler at a certain point.
#HorizontalPodAutoscalerCondition: {
	// type describes the current condition
	type: #HorizontalPodAutoscalerConditionType @go(Type) @protobuf(1,bytes)

	// status is the status of the condition (True, False, Unknown)
	status: v1.#ConditionStatus @go(Status) @protobuf(2,bytes)

	// lastTransitionTime is the last time the condition transitioned from
	// one status to another
	// +optional
	lastTransitionTime?: metav1.#Time @go(LastTransitionTime) @protobuf(3,bytes,opt)

	// reason is the reason for the condition's last transition.
	// +optional
	reason?: string @go(Reason) @protobuf(4,bytes,opt)

	// message is a human-readable explanation containing details about
	// the transition
	// +optional
	message?: string @go(Message) @protobuf(5,bytes,opt)
}

// MetricStatus describes the last-read state of a single metric.
#MetricStatus: {
	// type is the type of metric source.  It will be one of "ContainerResource", "External",
	// "Object", "Pods" or "Resource", each corresponds to a matching field in the object.
	// Note: "ContainerResource" type is available on when the feature-gate
	// HPAContainerMetrics is enabled
	type: #MetricSourceType @go(Type) @protobuf(1,bytes)

	// object refers to a metric describing a single kubernetes object
	// (for example, hits-per-second on an Ingress object).
	// +optional
	object?: null | #ObjectMetricStatus @go(Object,*ObjectMetricStatus) @protobuf(2,bytes,opt)

	// pods refers to a metric describing each pod in the current scale target
	// (for example, transactions-processed-per-second).  The values will be
	// averaged together before being compared to the target value.
	// +optional
	pods?: null | #PodsMetricStatus @go(Pods,*PodsMetricStatus) @protobuf(3,bytes,opt)

	// resource refers to a resource metric (such as those specified in
	// requests and limits) known to Kubernetes describing each pod in the
	// current scale target (e.g. CPU or memory). Such metrics are built in to
	// Kubernetes, and have special scaling options on top of those available
	// to normal per-pod metrics using the "pods" source.
	// +optional
	resource?: null | #ResourceMetricStatus @go(Resource,*ResourceMetricStatus) @protobuf(4,bytes,opt)

	// container resource refers to a resource metric (such as those specified in
	// requests and limits) known to Kubernetes describing a single container in each pod in the
	// current scale target (e.g. CPU or memory). Such metrics are built in to
	// Kubernetes, and have special scaling options on top of those available
	// to normal per-pod metrics using the "pods" source.
	// +optional
	containerResource?: null | #ContainerResourceMetricStatus @go(ContainerResource,*ContainerResourceMetricStatus) @protobuf(7,bytes,opt)

	// external refers to a global metric that is not associated
	// with any Kubernetes object. It allows autoscaling based on information
	// coming from components running outside of cluster
	// (for example length of queue in cloud messaging service, or
	// QPS from loadbalancer running outside of cluster).
	// +optional
	external?: null | #ExternalMetricStatus @go(External,*ExternalMetricStatus) @protobuf(5,bytes,opt)
}

// ObjectMetricStatus indicates the current value of a metric describing a
// kubernetes object (for example, hits-per-second on an Ingress object).
#ObjectMetricStatus: {
	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(1,bytes)

	// current contains the current value for the given metric
	current: #MetricValueStatus @go(Current) @protobuf(2,bytes)

	// DescribedObject specifies the descriptions of a object,such as kind,name apiVersion
	describedObject: #CrossVersionObjectReference @go(DescribedObject) @protobuf(3,bytes)
}

// PodsMetricStatus indicates the current value of a metric describing each pod in
// the current scale target (for example, transactions-processed-per-second).
#PodsMetricStatus: {
	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(1,bytes)

	// current contains the current value for the given metric
	current: #MetricValueStatus @go(Current) @protobuf(2,bytes)
}

// ResourceMetricStatus indicates the current value of a resource metric known to
// Kubernetes, as specified in requests and limits, describing each pod in the
// current scale target (e.g. CPU or memory).  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available to
// normal per-pod metrics using the "pods" source.
#ResourceMetricStatus: {
	// name is the name of the resource in question.
	name: v1.#ResourceName @go(Name) @protobuf(1,bytes)

	// current contains the current value for the given metric
	current: #MetricValueStatus @go(Current) @protobuf(2,bytes)
}

// ContainerResourceMetricStatus indicates the current value of a resource metric known to
// Kubernetes, as specified in requests and limits, describing a single container in each pod in the
// current scale target (e.g. CPU or memory).  Such metrics are built in to
// Kubernetes, and have special scaling options on top of those available to
// normal per-pod metrics using the "pods" source.
#ContainerResourceMetricStatus: {
	// name is the name of the resource in question.
	name: v1.#ResourceName @go(Name) @protobuf(1,bytes)

	// current contains the current value for the given metric
	current: #MetricValueStatus @go(Current) @protobuf(2,bytes)

	// container is the name of the container in the pods of the scaling target
	container: string @go(Container) @protobuf(3,bytes,opt)
}

// ExternalMetricStatus indicates the current value of a global metric
// not associated with any Kubernetes object.
#ExternalMetricStatus: {
	// metric identifies the target metric by name and selector
	metric: #MetricIdentifier @go(Metric) @protobuf(1,bytes)

	// current contains the current value for the given metric
	current: #MetricValueStatus @go(Current) @protobuf(2,bytes)
}

// MetricValueStatus holds the current value for a metric
#MetricValueStatus: {
	// value is the current value of the metric (as a quantity).
	// +optional
	value?: null | resource.#Quantity @go(Value,*resource.Quantity) @protobuf(1,bytes,opt)

	// averageValue is the current value of the average of the
	// metric across all relevant pods (as a quantity)
	// +optional
	averageValue?: null | resource.#Quantity @go(AverageValue,*resource.Quantity) @protobuf(2,bytes,opt)

	// currentAverageUtilization is the current value of the average of the
	// resource metric across all relevant pods, represented as a percentage of
	// the requested value of the resource for the pods.
	// +optional
	averageUtilization?: null | int32 @go(AverageUtilization,*int32) @protobuf(3,bytes,opt)
}

// HorizontalPodAutoscalerList is a list of horizontal pod autoscaler objects.
#HorizontalPodAutoscalerList: {
	metav1.#TypeMeta

	// metadata is the standard list metadata.
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items is the list of horizontal pod autoscaler objects.
	items: [...#HorizontalPodAutoscaler] @go(Items,[]HorizontalPodAutoscaler) @protobuf(2,bytes,rep)
}
