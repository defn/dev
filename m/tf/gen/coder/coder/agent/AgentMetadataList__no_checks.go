//go:build no_runtime_type_checking

package agent

// Building without runtime type checking enabled, so all the below just return nil

func (a *jsiiProxy_AgentMetadataList) validateAllWithMapKeyParameters(mapKeyAttributeName *string) error {
	return nil
}

func (a *jsiiProxy_AgentMetadataList) validateGetParameters(index *float64) error {
	return nil
}

func (a *jsiiProxy_AgentMetadataList) validateResolveParameters(_context cdktf.IResolveContext) error {
	return nil
}

func (j *jsiiProxy_AgentMetadataList) validateSetInternalValueParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_AgentMetadataList) validateSetTerraformAttributeParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_AgentMetadataList) validateSetTerraformResourceParameters(val cdktf.IInterpolatingParent) error {
	return nil
}

func (j *jsiiProxy_AgentMetadataList) validateSetWrapsSetParameters(val *bool) error {
	return nil
}

func validateNewAgentMetadataListParameters(terraformResource cdktf.IInterpolatingParent, terraformAttribute *string, wrapsSet *bool) error {
	return nil
}
