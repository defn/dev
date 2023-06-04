//go:build no_runtime_type_checking

package egg

// Building without runtime type checking enabled, so all the below just return nil

func (e *jsiiProxy_Egg) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (e *jsiiProxy_Egg) validateAddProviderParameters(provider interface{}) error {
	return nil
}

func (e *jsiiProxy_Egg) validateGetStringParameters(output *string) error {
	return nil
}

func (e *jsiiProxy_Egg) validateInterpolationForOutputParameters(moduleOutput *string) error {
	return nil
}

func (e *jsiiProxy_Egg) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateEgg_IsConstructParameters(x interface{}) error {
	return nil
}

func validateEgg_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Egg) validateSetEggParameters(val *string) error {
	return nil
}

func validateNewEggParameters(scope constructs.Construct, id *string, config *EggConfig) error {
	return nil
}

