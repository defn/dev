package infra

import (
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"

	"github.com/aws/jsii-runtime-go"
)

type AwsAdmin struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

type AwsAccount struct {
	Name     string                        `json:"name"`
	Email    string                        `json:"email"`
	Profile  string                        `json:"profile"`
	Prefix   string                        `json:"prefix"`
	Imported string                        `json:"imported"`
	Region   string                        `json:"region"`
	Cfg      CfgTerraformAwsS3BucketConfig `json:"cfg"`

	Url string `json:"url"`
	Id  string `json:"id"`
}

type AwsBackend struct {
	Lock    string `json:"lock"`
	Bucket  string `json:"bucket"`
	Region  string `json:"region"`
	Profile string `json:"profile"`
}

type AwsOrganization struct {
	Name     string       `json:"name"`
	Region   string       `json:"region"`
	Accounts []AwsAccount `json:"accounts"`
	Admins   []AwsAdmin   `json:"admins"`

	OpsOrgName     string `json:"ops_org_name"`
	OpsAccountName string `json:"ops_account_name"`
	OpsAccountID   string `json:"ops_account_id"`
}

type CfgTerraformAwsS3BucketConfig struct {
	Id                *string    `json:"id"`
	Enabled           *bool      `json:"enabled"`
	Namespace         *string    `json:"namespace"`
	Stage             *string    `json:"stage"`
	Name              *string    `json:"name"`
	Attributes        *[]*string `json:"attributes"`
	Acl               *string    `json:"acl"`
	UserEnabled       *bool      `json:"user_enabled"`
	VersioningEnabled *bool      `json:"versioning_enabled"`
}

type AwsProps struct {
	Backend      AwsBackend                 `json:"backend"`
	Organization map[string]AwsOrganization `json:"organization"`
	Accounts     []string                   `json:"accounts"`
}

// alias
func Js(s string) *string {
	return jsii.String(s)
}

//lint:ignore U1000 utility
func Jsn(v float64) *float64 {
	return jsii.Number(v)
}

//lint:ignore U1000 utility
func Jsf(s string, a ...any) *string {
	return Js(fmt.Sprintf(s, a...))
}

//lint:ignore U1000 utility
func Jstrue() *bool {
	return jsii.Bool(true)
}

//lint:ignore U1000 utility
func Jsfalse() *bool {
	return jsii.Bool(false)
}

//lint:ignore U1000 utility
func Jsbool(b bool) *bool {
	return jsii.Bool(b)
}

func LoadUserAwsProps(infra_schema string) AwsProps {
	ctx := cuecontext.New()

	user_schema := ctx.CompileString(infra_schema)

	user_input_instance := load.Instances([]string{"."}, nil)[0]
	user_input := ctx.BuildInstance(user_input_instance)

	user_schema.Unify(user_input)

	var aws_props AwsProps
	user_input.LookupPath(cue.ParsePath("input")).Decode(&aws_props)

	return aws_props
}
