//go:build no_runtime_type_checking

package chicken

// Building without runtime type checking enabled, so all the below just return nil

func (c *jsiiProxy_Chicken) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (c *jsiiProxy_Chicken) validateAddProviderParameters(provider interface{}) error {
	return nil
}

func (c *jsiiProxy_Chicken) validateGetStringParameters(output *string) error {
	return nil
}

func (c *jsiiProxy_Chicken) validateInterpolationForOutputParameters(moduleOutput *string) error {
	return nil
}

func (c *jsiiProxy_Chicken) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateChicken_IsConstructParameters(x interface{}) error {
	return nil
}

func validateChicken_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Chicken) validateSetChickenParameters(val *string) error {
	return nil
}

func validateNewChickenParameters(scope constructs.Construct, id *string, config *ChickenConfig) error {
	return nil
}

