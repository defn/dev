//go:build no_runtime_type_checking

package app

// Building without runtime type checking enabled, so all the below just return nil

func (a *jsiiProxy_App) validateAddMoveTargetParameters(moveTarget *string) error {
	return nil
}

func (a *jsiiProxy_App) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (a *jsiiProxy_App) validateGetAnyMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetBooleanAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetBooleanMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetNumberAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetNumberListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetNumberMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetStringAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateGetStringMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateImportFromParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_App) validateInterpolationForAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_App) validateMoveFromIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_App) validateMoveToParameters(moveTarget *string, index interface{}) error {
	return nil
}

func (a *jsiiProxy_App) validateMoveToIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_App) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func (a *jsiiProxy_App) validatePutHealthcheckParameters(value *AppHealthcheck) error {
	return nil
}

func validateApp_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateApp_IsConstructParameters(x interface{}) error {
	return nil
}

func validateApp_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateApp_IsTerraformResourceParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetAgentIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetCommandParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetConnectionParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetCountParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetDisplayNameParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetExternalParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetIconParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetLifecycleParameters(val *cdktf.TerraformResourceLifecycle) error {
	return nil
}

func (j *jsiiProxy_App) validateSetNameParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetProvisionersParameters(val *[]interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetRelativePathParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetShareParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetSlugParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_App) validateSetSubdomainParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_App) validateSetUrlParameters(val *string) error {
	return nil
}

func validateNewAppParameters(scope constructs.Construct, id *string, config *AppConfig) error {
	return nil
}
