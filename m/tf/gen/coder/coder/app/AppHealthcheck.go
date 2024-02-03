package app

type AppHealthcheck struct {
	// Duration in seconds to wait between healthcheck requests.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#interval App#interval}
	Interval *float64 `field:"required" json:"interval" yaml:"interval"`
	// Number of consecutive heathcheck failures before returning an unhealthy status.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#threshold App#threshold}
	Threshold *float64 `field:"required" json:"threshold" yaml:"threshold"`
	// HTTP address used determine the application readiness.
	//
	// A successful health check is a HTTP response code less than 500 returned before healthcheck.interval seconds.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#url App#url}
	Url *string `field:"required" json:"url" yaml:"url"`
}
