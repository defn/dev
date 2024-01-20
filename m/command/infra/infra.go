package command

import (
	_ "embed"

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

type AwsOrganization struct {
	Name     string     `json:"name"`
	Region   string     `json:"region"`
	Prefix   string     `json:"prefix"`
	Domain   string     `json:"domain"`
	Accounts []string   `json:"accounts"`
	Admins   []AwsAdmin `json:"admins"`
}

type KubernetesCluster struct {
	Name   string
	Region string `json:"region"`

	NodeGroup map[string]KubernetesNodeGroup `json:"nodegroup"`

	VPC struct {
		CIDRs []string `json:"cidrs"`
	} `json:"vpc"`
}

type KubernetesNodeGroup struct {
	Name string

	InstanceTypes []string `json:"instance_types"`

	AZ map[string]AWSVPCNetwork `json:"az"`
}

type AWSVPCNetwork struct {
	Network string `json:"network"`
}

type AwsProps struct {
	Organization map[string]AwsOrganization `json:"organization"`

	Kubernetes map[string]KubernetesCluster `json:"kubernetes"`
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
