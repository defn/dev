package c

discovery_url: string

discovery: {
	issuer:                 discovery_url
	jwks_uri:               "\(discovery_url)/openid/.well-known/jwks.json"
	authorization_endpoint: "urn:kubernetes:programmatic_authorization"
	response_types_supported: [
		"id_token",
	]
	subject_types_supported: [
		"public",
	]
	id_token_signing_alg_values_supported: [
		"RS256",
	]
	claims_supported: [
		"sub",
		"iss",
	]
}
