//go:build no_runtime_type_checking

package datacoderparameter

// Building without runtime type checking enabled, so all the below just return nil

func (d *jsiiProxy_DataCoderParameterOptionList) validateAllWithMapKeyParameters(mapKeyAttributeName *string) error {
	return nil
}

func (d *jsiiProxy_DataCoderParameterOptionList) validateGetParameters(index *float64) error {
	return nil
}

func (d *jsiiProxy_DataCoderParameterOptionList) validateResolveParameters(_context cdktf.IResolveContext) error {
	return nil
}

func (j *jsiiProxy_DataCoderParameterOptionList) validateSetInternalValueParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_DataCoderParameterOptionList) validateSetTerraformAttributeParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_DataCoderParameterOptionList) validateSetTerraformResourceParameters(val cdktf.IInterpolatingParent) error {
	return nil
}

func (j *jsiiProxy_DataCoderParameterOptionList) validateSetWrapsSetParameters(val *bool) error {
	return nil
}

func validateNewDataCoderParameterOptionListParameters(terraformResource cdktf.IInterpolatingParent, terraformAttribute *string, wrapsSet *bool) error {
	return nil
}
