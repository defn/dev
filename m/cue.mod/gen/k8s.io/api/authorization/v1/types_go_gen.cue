// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/authorization/v1

package v1

import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

// SubjectAccessReview checks whether or not a user or group can perform an action.
#SubjectAccessReview: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec holds information about the request being evaluated
	spec: #SubjectAccessReviewSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is filled in by the server and indicates whether the request is allowed or not
	// +optional
	status?: #SubjectAccessReviewStatus @go(Status) @protobuf(3,bytes,opt)
}

// SelfSubjectAccessReview checks whether or the current user can perform an action.  Not filling in a
// spec.namespace means "in all namespaces".  Self is a special case, because users should always be able
// to check whether they can perform an action
#SelfSubjectAccessReview: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec holds information about the request being evaluated.  user and groups must be empty
	spec: #SelfSubjectAccessReviewSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is filled in by the server and indicates whether the request is allowed or not
	// +optional
	status?: #SubjectAccessReviewStatus @go(Status) @protobuf(3,bytes,opt)
}

// LocalSubjectAccessReview checks whether or not a user or group can perform an action in a given namespace.
// Having a namespace scoped resource makes it much easier to grant namespace scoped policy that includes permissions
// checking.
#LocalSubjectAccessReview: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec holds information about the request being evaluated.  spec.namespace must be equal to the namespace
	// you made the request against.  If empty, it is defaulted.
	spec: #SubjectAccessReviewSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is filled in by the server and indicates whether the request is allowed or not
	// +optional
	status?: #SubjectAccessReviewStatus @go(Status) @protobuf(3,bytes,opt)
}

// ResourceAttributes includes the authorization attributes available for resource requests to the Authorizer interface
#ResourceAttributes: {
	// Namespace is the namespace of the action being requested.  Currently, there is no distinction between no namespace and all namespaces
	// "" (empty) is defaulted for LocalSubjectAccessReviews
	// "" (empty) is empty for cluster-scoped resources
	// "" (empty) means "all" for namespace scoped resources from a SubjectAccessReview or SelfSubjectAccessReview
	// +optional
	namespace?: string @go(Namespace) @protobuf(1,bytes,opt)

	// Verb is a kubernetes resource API verb, like: get, list, watch, create, update, delete, proxy.  "*" means all.
	// +optional
	verb?: string @go(Verb) @protobuf(2,bytes,opt)

	// Group is the API Group of the Resource.  "*" means all.
	// +optional
	group?: string @go(Group) @protobuf(3,bytes,opt)

	// Version is the API Version of the Resource.  "*" means all.
	// +optional
	version?: string @go(Version) @protobuf(4,bytes,opt)

	// Resource is one of the existing resource types.  "*" means all.
	// +optional
	resource?: string @go(Resource) @protobuf(5,bytes,opt)

	// Subresource is one of the existing resource types.  "" means none.
	// +optional
	subresource?: string @go(Subresource) @protobuf(6,bytes,opt)

	// Name is the name of the resource being requested for a "get" or deleted for a "delete". "" (empty) means all.
	// +optional
	name?: string @go(Name) @protobuf(7,bytes,opt)
}

// NonResourceAttributes includes the authorization attributes available for non-resource requests to the Authorizer interface
#NonResourceAttributes: {
	// Path is the URL path of the request
	// +optional
	path?: string @go(Path) @protobuf(1,bytes,opt)

	// Verb is the standard HTTP verb
	// +optional
	verb?: string @go(Verb) @protobuf(2,bytes,opt)
}

// SubjectAccessReviewSpec is a description of the access request.  Exactly one of ResourceAuthorizationAttributes
// and NonResourceAuthorizationAttributes must be set
#SubjectAccessReviewSpec: {
	// ResourceAuthorizationAttributes describes information for a resource access request
	// +optional
	resourceAttributes?: null | #ResourceAttributes @go(ResourceAttributes,*ResourceAttributes) @protobuf(1,bytes,opt)

	// NonResourceAttributes describes information for a non-resource access request
	// +optional
	nonResourceAttributes?: null | #NonResourceAttributes @go(NonResourceAttributes,*NonResourceAttributes) @protobuf(2,bytes,opt)

	// User is the user you're testing for.
	// If you specify "User" but not "Groups", then is it interpreted as "What if User were not a member of any groups
	// +optional
	user?: string @go(User) @protobuf(3,bytes,opt)

	// Groups is the groups you're testing for.
	// +optional
	// +listType=atomic
	groups?: [...string] @go(Groups,[]string) @protobuf(4,bytes,rep)

	// Extra corresponds to the user.Info.GetExtra() method from the authenticator.  Since that is input to the authorizer
	// it needs a reflection here.
	// +optional
	extra?: {[string]: #ExtraValue} @go(Extra,map[string]ExtraValue) @protobuf(5,bytes,rep)

	// UID information about the requesting user.
	// +optional
	uid?: string @go(UID) @protobuf(6,bytes,opt)
}

// ExtraValue masks the value so protobuf can generate
// +protobuf.nullable=true
// +protobuf.options.(gogoproto.goproto_stringer)=false
#ExtraValue: [...string]

// SelfSubjectAccessReviewSpec is a description of the access request.  Exactly one of ResourceAuthorizationAttributes
// and NonResourceAuthorizationAttributes must be set
#SelfSubjectAccessReviewSpec: {
	// ResourceAuthorizationAttributes describes information for a resource access request
	// +optional
	resourceAttributes?: null | #ResourceAttributes @go(ResourceAttributes,*ResourceAttributes) @protobuf(1,bytes,opt)

	// NonResourceAttributes describes information for a non-resource access request
	// +optional
	nonResourceAttributes?: null | #NonResourceAttributes @go(NonResourceAttributes,*NonResourceAttributes) @protobuf(2,bytes,opt)
}

// SubjectAccessReviewStatus
#SubjectAccessReviewStatus: {
	// Allowed is required. True if the action would be allowed, false otherwise.
	allowed: bool @go(Allowed) @protobuf(1,varint,opt)

	// Denied is optional. True if the action would be denied, otherwise
	// false. If both allowed is false and denied is false, then the
	// authorizer has no opinion on whether to authorize the action. Denied
	// may not be true if Allowed is true.
	// +optional
	denied?: bool @go(Denied) @protobuf(4,varint,opt)

	// Reason is optional.  It indicates why a request was allowed or denied.
	// +optional
	reason?: string @go(Reason) @protobuf(2,bytes,opt)

	// EvaluationError is an indication that some error occurred during the authorization check.
	// It is entirely possible to get an error and be able to continue determine authorization status in spite of it.
	// For instance, RBAC can be missing a role, but enough roles are still present and bound to reason about the request.
	// +optional
	evaluationError?: string @go(EvaluationError) @protobuf(3,bytes,opt)
}

// SelfSubjectRulesReview enumerates the set of actions the current user can perform within a namespace.
// The returned list of actions may be incomplete depending on the server's authorization mode,
// and any errors experienced during the evaluation. SelfSubjectRulesReview should be used by UIs to show/hide actions,
// or to quickly let an end user reason about their permissions. It should NOT Be used by external systems to
// drive authorization decisions as this raises confused deputy, cache lifetime/revocation, and correctness concerns.
// SubjectAccessReview, and LocalAccessReview are the correct way to defer authorization decisions to the API server.
#SelfSubjectRulesReview: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec holds information about the request being evaluated.
	spec: #SelfSubjectRulesReviewSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is filled in by the server and indicates the set of actions a user can perform.
	// +optional
	status?: #SubjectRulesReviewStatus @go(Status) @protobuf(3,bytes,opt)
}

// SelfSubjectRulesReviewSpec defines the specification for SelfSubjectRulesReview.
#SelfSubjectRulesReviewSpec: {
	// Namespace to evaluate rules for. Required.
	namespace?: string @go(Namespace) @protobuf(1,bytes,opt)
}

// SubjectRulesReviewStatus contains the result of a rules check. This check can be incomplete depending on
// the set of authorizers the server is configured with and any errors experienced during evaluation.
// Because authorization rules are additive, if a rule appears in a list it's safe to assume the subject has that permission,
// even if that list is incomplete.
#SubjectRulesReviewStatus: {
	// ResourceRules is the list of actions the subject is allowed to perform on resources.
	// The list ordering isn't significant, may contain duplicates, and possibly be incomplete.
	// +listType=atomic
	resourceRules: [...#ResourceRule] @go(ResourceRules,[]ResourceRule) @protobuf(1,bytes,rep)

	// NonResourceRules is the list of actions the subject is allowed to perform on non-resources.
	// The list ordering isn't significant, may contain duplicates, and possibly be incomplete.
	// +listType=atomic
	nonResourceRules: [...#NonResourceRule] @go(NonResourceRules,[]NonResourceRule) @protobuf(2,bytes,rep)

	// Incomplete is true when the rules returned by this call are incomplete. This is most commonly
	// encountered when an authorizer, such as an external authorizer, doesn't support rules evaluation.
	incomplete: bool @go(Incomplete) @protobuf(3,bytes,rep)

	// EvaluationError can appear in combination with Rules. It indicates an error occurred during
	// rule evaluation, such as an authorizer that doesn't support rule evaluation, and that
	// ResourceRules and/or NonResourceRules may be incomplete.
	// +optional
	evaluationError?: string @go(EvaluationError) @protobuf(4,bytes,opt)
}

// ResourceRule is the list of actions the subject is allowed to perform on resources. The list ordering isn't significant,
// may contain duplicates, and possibly be incomplete.
#ResourceRule: {
	// Verb is a list of kubernetes resource API verbs, like: get, list, watch, create, update, delete, proxy.  "*" means all.
	// +listType=atomic
	verbs: [...string] @go(Verbs,[]string) @protobuf(1,bytes,rep)

	// APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of
	// the enumerated resources in any API group will be allowed.  "*" means all.
	// +optional
	// +listType=atomic
	apiGroups?: [...string] @go(APIGroups,[]string) @protobuf(2,bytes,rep)

	// Resources is a list of resources this rule applies to.  "*" means all in the specified apiGroups.
	//  "*/foo" represents the subresource 'foo' for all resources in the specified apiGroups.
	// +optional
	// +listType=atomic
	resources?: [...string] @go(Resources,[]string) @protobuf(3,bytes,rep)

	// ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.  "*" means all.
	// +optional
	// +listType=atomic
	resourceNames?: [...string] @go(ResourceNames,[]string) @protobuf(4,bytes,rep)
}

// NonResourceRule holds information that describes a rule for the non-resource
#NonResourceRule: {
	// Verb is a list of kubernetes non-resource API verbs, like: get, post, put, delete, patch, head, options.  "*" means all.
	// +listType=atomic
	verbs: [...string] @go(Verbs,[]string) @protobuf(1,bytes,rep)

	// NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full,
	// final step in the path.  "*" means all.
	// +optional
	// +listType=atomic
	nonResourceURLs?: [...string] @go(NonResourceURLs,[]string) @protobuf(2,bytes,rep)
}
