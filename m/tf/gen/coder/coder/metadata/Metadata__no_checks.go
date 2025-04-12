//go:build no_runtime_type_checking

package metadata

// Building without runtime type checking enabled, so all the below just return nil

func (m *jsiiProxy_Metadata) validateAddMoveTargetParameters(moveTarget *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetAnyMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetBooleanAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetBooleanMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetNumberAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetNumberListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetNumberMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetStringAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateGetStringMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateImportFromParameters(id *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateInterpolationForAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateMoveFromIdParameters(id *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateMoveToParameters(moveTarget *string, index interface{}) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateMoveToIdParameters(id *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func (m *jsiiProxy_Metadata) validatePutItemParameters(value interface{}) error {
	return nil
}

func validateMetadata_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateMetadata_IsConstructParameters(x interface{}) error {
	return nil
}

func validateMetadata_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateMetadata_IsTerraformResourceParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetConnectionParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetCountParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetDailyCostParameters(val *float64) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetHideParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetIconParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetLifecycleParameters(val *cdktf.TerraformResourceLifecycle) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetProvisionersParameters(val *[]interface{}) error {
	return nil
}

func (j *jsiiProxy_Metadata) validateSetResourceIdParameters(val *string) error {
	return nil
}

func validateNewMetadataParameters(scope constructs.Construct, id *string, config *MetadataConfig) error {
	return nil
}
