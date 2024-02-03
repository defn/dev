//go:build no_runtime_type_checking

package metadata

// Building without runtime type checking enabled, so all the below just return nil

func (m *jsiiProxy_MetadataItemList) validateAllWithMapKeyParameters(mapKeyAttributeName *string) error {
	return nil
}

func (m *jsiiProxy_MetadataItemList) validateGetParameters(index *float64) error {
	return nil
}

func (m *jsiiProxy_MetadataItemList) validateResolveParameters(_context cdktf.IResolveContext) error {
	return nil
}

func (j *jsiiProxy_MetadataItemList) validateSetInternalValueParameters(val interface{}) error {
	return nil
}

func (j *jsiiProxy_MetadataItemList) validateSetTerraformAttributeParameters(val *string) error {
	return nil
}

func (j *jsiiProxy_MetadataItemList) validateSetTerraformResourceParameters(val cdktf.IInterpolatingParent) error {
	return nil
}

func (j *jsiiProxy_MetadataItemList) validateSetWrapsSetParameters(val *bool) error {
	return nil
}

func validateNewMetadataItemListParameters(terraformResource cdktf.IInterpolatingParent, terraformAttribute *string, wrapsSet *bool) error {
	return nil
}
