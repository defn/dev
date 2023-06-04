//go:build no_runtime_type_checking

package devpod

// Building without runtime type checking enabled, so all the below just return nil

func (d *jsiiProxy_Devpod) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (d *jsiiProxy_Devpod) validateAddProviderParameters(provider interface{}) error {
	return nil
}

func (d *jsiiProxy_Devpod) validateGetStringParameters(output *string) error {
	return nil
}

func (d *jsiiProxy_Devpod) validateInterpolationForOutputParameters(moduleOutput *string) error {
	return nil
}

func (d *jsiiProxy_Devpod) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateDevpod_IsConstructParameters(x interface{}) error {
	return nil
}

func validateDevpod_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Devpod) validateSetEnvsParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Devpod) validateSetRepoParameters(val interface{}) error {
	return nil
}

func validateNewDevpodParameters(scope constructs.Construct, id *string, config *DevpodConfig) error {
	return nil
}

