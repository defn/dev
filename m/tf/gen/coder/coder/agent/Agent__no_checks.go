//go:build no_runtime_type_checking

package agent

// Building without runtime type checking enabled, so all the below just return nil

func (a *jsiiProxy_Agent) validateAddMoveTargetParameters(moveTarget *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetAnyMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetBooleanAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetBooleanMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetNumberAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetNumberListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetNumberMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetStringAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateGetStringMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateImportFromParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateInterpolationForAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateMoveFromIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateMoveToParameters(moveTarget *string, index interface{}) error {
	return nil
}

func (a *jsiiProxy_Agent) validateMoveToIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func (a *jsiiProxy_Agent) validatePutDisplayAppsParameters(value *AgentDisplayApps) error {
	return nil
}

func (a *jsiiProxy_Agent) validatePutMetadataParameters(value interface{}) error {
	return nil
}

func validateAgent_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateAgent_IsConstructParameters(x interface{}) error {
	return nil
}

func validateAgent_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateAgent_IsTerraformResourceParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetArchParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetAuthParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetConnectionParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetConnectionTimeoutParameters(val *float64) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetCountParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetDirParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetEnvParameters(val *map[string]*string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetLifecycleParameters(val *cdktf.TerraformResourceLifecycle) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetLoginBeforeReadyParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetMotdFileParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetOsParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetProvisionersParameters(val *[]interface{}) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetShutdownScriptParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetShutdownScriptTimeoutParameters(val *float64) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetStartupScriptParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetStartupScriptBehaviorParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetStartupScriptTimeoutParameters(val *float64) error {
	return nil
}

func (j *jsiiProxy_Agent) validateSetTroubleshootingUrlParameters(val *string) error {
	return nil
}

func validateNewAgentParameters(scope constructs.Construct, id *string, config *AgentConfig) error {
	return nil
}
