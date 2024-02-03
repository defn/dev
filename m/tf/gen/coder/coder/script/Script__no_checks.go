//go:build no_runtime_type_checking

package script

// Building without runtime type checking enabled, so all the below just return nil

func (s *jsiiProxy_Script) validateAddMoveTargetParameters(moveTarget *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetAnyMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetBooleanAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetBooleanMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetNumberAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetNumberListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetNumberMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetStringAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateGetStringMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateImportFromParameters(id *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateInterpolationForAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateMoveFromIdParameters(id *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateMoveToParameters(moveTarget *string, index interface{}) error {
	return nil
}

func (s *jsiiProxy_Script) validateMoveToIdParameters(id *string) error {
	return nil
}

func (s *jsiiProxy_Script) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateScript_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateScript_IsConstructParameters(x interface{}) error {
	return nil
}

func validateScript_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateScript_IsTerraformResourceParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetAgentIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetConnectionParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetCountParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetCronParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetDisplayNameParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetIconParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetLifecycleParameters(val *cdktf.TerraformResourceLifecycle) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetLogPathParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetProvisionersParameters(val *[]interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetRunOnStartParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetRunOnStopParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetScriptParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetStartBlocksLoginParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Script) validateSetTimeoutParameters(val *float64) error {
	return nil
}

func validateNewScriptParameters(scope constructs.Construct, id *string, config *ScriptConfig) error {
	return nil
}
