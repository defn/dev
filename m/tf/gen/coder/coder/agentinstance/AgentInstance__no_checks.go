//go:build no_runtime_type_checking

package agentinstance

// Building without runtime type checking enabled, so all the below just return nil

func (a *jsiiProxy_AgentInstance) validateAddMoveTargetParameters(moveTarget *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateAddOverrideParameters(path *string, value interface{}) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetAnyMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetBooleanAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetBooleanMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetNumberAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetNumberListAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetNumberMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetStringAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateGetStringMapAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateImportFromParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateInterpolationForAttributeParameters(terraformAttribute *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateMoveFromIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateMoveToParameters(moveTarget *string, index interface{}) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateMoveToIdParameters(id *string) error {
	return nil
}

func (a *jsiiProxy_AgentInstance) validateOverrideLogicalIdParameters(newLogicalId *string) error {
	return nil
}

func validateAgentInstance_GenerateConfigForImportParameters(scope constructs.Construct, importToId *string, importFromId *string) error {
	return nil
}

func validateAgentInstance_IsConstructParameters(x interface{}) error {
	return nil
}

func validateAgentInstance_IsTerraformElementParameters(x interface{}) error {
	return nil
}

func validateAgentInstance_IsTerraformResourceParameters(x interface{}) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetAgentIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetConnectionParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetCountParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetInstanceIdParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetLifecycleParameters(val *cdktf.TerraformResourceLifecycle) error {
	return nil
}

func (j *jsiiProxy_AgentInstance) validateSetProvisionersParameters(val *[]interface{}) error {
	return nil
}

func validateNewAgentInstanceParameters(scope constructs.Construct, id *string, config *AgentInstanceConfig) error {
	return nil
}
