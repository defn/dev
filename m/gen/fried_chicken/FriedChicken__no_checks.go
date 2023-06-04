//go:build no_runtime_type_checking

package fried_chicken

// Building without runtime type checking enabled, so all the below just return nil

func (f *jsiiProxy_FriedChicken) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (f *jsiiProxy_FriedChicken) validateAddProviderParameters(provider interface{}) error {
	return nil
}

func (f *jsiiProxy_FriedChicken) validateGetStringParameters(output *string) error {
	return nil
}

func (f *jsiiProxy_FriedChicken) validateInterpolationForOutputParameters(moduleOutput *string) error {
	return nil
}

func (f *jsiiProxy_FriedChicken) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateFriedChicken_IsConstructParameters(x interface{}) error {
	return nil
}

func validateFriedChicken_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateNewFriedChickenParameters(scope constructs.Construct, id *string, config *FriedChickenConfig) error {
	return nil
}

