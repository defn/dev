//go:build no_runtime_type_checking

package provider

// Building without runtime type checking enabled, so all the below just return nil

func (c *jsiiProxy_CoderProvider) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (c *jsiiProxy_CoderProvider) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateCoderProvider_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateCoderProvider_IsConstructParameters(x interface{}) error {
	return nil
}

func validateCoderProvider_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateCoderProvider_IsTerraformProviderParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_CoderProvider) validateSetFeatureUseManagedVariablesParameters(val interface{}) error {
	return nil
}

func validateNewCoderProviderParameters(scope constructs.Construct, id *string, config *CoderProviderConfig) error {
	return nil
}
