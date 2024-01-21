// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.32.0
// 	protoc        (unknown)
// source: legumes/v1/pea.proto

// $schema: defn.dev.legumes.v1.Pea
// $title: Cool pea
// $description: So many cool peas
// $location: https://defn.dev/legumes/pea/v1

// cool

package legumesv1

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

// <!-- crd generation tags
// +cue-gen:Pea:groupName:legumes.defn.dev
// +cue-gen:Pea:version:v1
// +cue-gen:Pea:storageVersion
// +cue-gen:Pea:subresource:status
// +cue-gen:Pea:scope:Namespaced
// +cue-gen:Pea:preserveUnknownFields:pluginConfig
// -->
//
// <!-- go code generation tags
// +kubetype-gen
// +kubetype-gen:groupVersion=legumes.defn.dev/v1
// +genclient
// +k8s:deepcopy-gen=true
// -->
// cool
type Pea struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	// cool
	Url string `protobuf:"bytes,1,opt,name=url,proto3" json:"url,omitempty"`
	// cool
	Sha256 string `protobuf:"bytes,2,opt,name=sha256,proto3" json:"sha256,omitempty"`
}

func (x *Pea) Reset() {
	*x = Pea{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Pea) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Pea) ProtoMessage() {}

func (x *Pea) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Pea.ProtoReflect.Descriptor instead.
func (*Pea) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{0}
}

func (x *Pea) GetUrl() string {
	if x != nil {
		return x.Url
	}
	return ""
}

func (x *Pea) GetSha256() string {
	if x != nil {
		return x.Sha256
	}
	return ""
}

type GetPeaRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *GetPeaRequest) Reset() {
	*x = GetPeaRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetPeaRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetPeaRequest) ProtoMessage() {}

func (x *GetPeaRequest) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetPeaRequest.ProtoReflect.Descriptor instead.
func (*GetPeaRequest) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{1}
}

func (x *GetPeaRequest) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

type GetPeaResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *GetPeaResponse) Reset() {
	*x = GetPeaResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetPeaResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetPeaResponse) ProtoMessage() {}

func (x *GetPeaResponse) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetPeaResponse.ProtoReflect.Descriptor instead.
func (*GetPeaResponse) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{2}
}

func (x *GetPeaResponse) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

type PutPeaRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *PutPeaRequest) Reset() {
	*x = PutPeaRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[3]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PutPeaRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PutPeaRequest) ProtoMessage() {}

func (x *PutPeaRequest) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[3]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PutPeaRequest.ProtoReflect.Descriptor instead.
func (*PutPeaRequest) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{3}
}

func (x *PutPeaRequest) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

type PutPeaResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *PutPeaResponse) Reset() {
	*x = PutPeaResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[4]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PutPeaResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PutPeaResponse) ProtoMessage() {}

func (x *PutPeaResponse) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[4]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PutPeaResponse.ProtoReflect.Descriptor instead.
func (*PutPeaResponse) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{4}
}

func (x *PutPeaResponse) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

type DeletePeaRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *DeletePeaRequest) Reset() {
	*x = DeletePeaRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[5]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DeletePeaRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DeletePeaRequest) ProtoMessage() {}

func (x *DeletePeaRequest) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[5]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DeletePeaRequest.ProtoReflect.Descriptor instead.
func (*DeletePeaRequest) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{5}
}

func (x *DeletePeaRequest) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

type DeletePeaResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Req *Pea `protobuf:"bytes,1,opt,name=req,proto3" json:"req,omitempty"`
}

func (x *DeletePeaResponse) Reset() {
	*x = DeletePeaResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_legumes_v1_pea_proto_msgTypes[6]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DeletePeaResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DeletePeaResponse) ProtoMessage() {}

func (x *DeletePeaResponse) ProtoReflect() protoreflect.Message {
	mi := &file_legumes_v1_pea_proto_msgTypes[6]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DeletePeaResponse.ProtoReflect.Descriptor instead.
func (*DeletePeaResponse) Descriptor() ([]byte, []int) {
	return file_legumes_v1_pea_proto_rawDescGZIP(), []int{6}
}

func (x *DeletePeaResponse) GetReq() *Pea {
	if x != nil {
		return x.Req
	}
	return nil
}

var File_legumes_v1_pea_proto protoreflect.FileDescriptor

var file_legumes_v1_pea_proto_rawDesc = []byte{
	0x0a, 0x14, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2f, 0x76, 0x31, 0x2f, 0x70, 0x65, 0x61,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x13, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76,
	0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x22, 0x2f, 0x0a, 0x03, 0x50,
	0x65, 0x61, 0x12, 0x10, 0x0a, 0x03, 0x75, 0x72, 0x6c, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52,
	0x03, 0x75, 0x72, 0x6c, 0x12, 0x16, 0x0a, 0x06, 0x73, 0x68, 0x61, 0x32, 0x35, 0x36, 0x18, 0x02,
	0x20, 0x01, 0x28, 0x09, 0x52, 0x06, 0x73, 0x68, 0x61, 0x32, 0x35, 0x36, 0x22, 0x3b, 0x0a, 0x0d,
	0x47, 0x65, 0x74, 0x50, 0x65, 0x61, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x2a, 0x0a,
	0x03, 0x72, 0x65, 0x71, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66,
	0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31,
	0x2e, 0x50, 0x65, 0x61, 0x52, 0x03, 0x72, 0x65, 0x71, 0x22, 0x3c, 0x0a, 0x0e, 0x47, 0x65, 0x74,
	0x50, 0x65, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x2a, 0x0a, 0x03, 0x72,
	0x65, 0x71, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e,
	0x64, 0x65, 0x76, 0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50,
	0x65, 0x61, 0x52, 0x03, 0x72, 0x65, 0x71, 0x22, 0x3b, 0x0a, 0x0d, 0x50, 0x75, 0x74, 0x50, 0x65,
	0x61, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x2a, 0x0a, 0x03, 0x72, 0x65, 0x71, 0x18,
	0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76,
	0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x61, 0x52,
	0x03, 0x72, 0x65, 0x71, 0x22, 0x3c, 0x0a, 0x0e, 0x50, 0x75, 0x74, 0x50, 0x65, 0x61, 0x52, 0x65,
	0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x2a, 0x0a, 0x03, 0x72, 0x65, 0x71, 0x18, 0x01, 0x20,
	0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c,
	0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x61, 0x52, 0x03, 0x72,
	0x65, 0x71, 0x22, 0x3e, 0x0a, 0x10, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x61, 0x52,
	0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x2a, 0x0a, 0x03, 0x72, 0x65, 0x71, 0x18, 0x01, 0x20,
	0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c,
	0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x61, 0x52, 0x03, 0x72,
	0x65, 0x71, 0x22, 0x3f, 0x0a, 0x11, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x61, 0x52,
	0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x2a, 0x0a, 0x03, 0x72, 0x65, 0x71, 0x18, 0x01,
	0x20, 0x01, 0x28, 0x0b, 0x32, 0x18, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e,
	0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x61, 0x52, 0x03,
	0x72, 0x65, 0x71, 0x32, 0x99, 0x02, 0x0a, 0x0f, 0x50, 0x65, 0x61, 0x53, 0x74, 0x6f, 0x72, 0x65,
	0x53, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x12, 0x53, 0x0a, 0x06, 0x47, 0x65, 0x74, 0x50, 0x65,
	0x61, 0x12, 0x22, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c, 0x65, 0x67,
	0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x47, 0x65, 0x74, 0x50, 0x65, 0x61, 0x52, 0x65,
	0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x23, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76,
	0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x47, 0x65, 0x74, 0x50,
	0x65, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12, 0x53, 0x0a, 0x06,
	0x50, 0x75, 0x74, 0x50, 0x65, 0x61, 0x12, 0x22, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65,
	0x76, 0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x75, 0x74,
	0x50, 0x65, 0x61, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x23, 0x2e, 0x64, 0x65, 0x66,
	0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31,
	0x2e, 0x50, 0x75, 0x74, 0x50, 0x65, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22,
	0x00, 0x12, 0x5c, 0x0a, 0x09, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x61, 0x12, 0x25,
	0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76, 0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65,
	0x73, 0x2e, 0x76, 0x31, 0x2e, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x61, 0x52, 0x65,
	0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x26, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76,
	0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x2e, 0x44, 0x65, 0x6c, 0x65,
	0x74, 0x65, 0x50, 0x65, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x42,
	0xc7, 0x01, 0x0a, 0x17, 0x63, 0x6f, 0x6d, 0x2e, 0x64, 0x65, 0x66, 0x6e, 0x2e, 0x64, 0x65, 0x76,
	0x2e, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x76, 0x31, 0x42, 0x08, 0x50, 0x65, 0x61,
	0x50, 0x72, 0x6f, 0x74, 0x6f, 0x50, 0x01, 0x5a, 0x33, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e,
	0x63, 0x6f, 0x6d, 0x2f, 0x64, 0x65, 0x66, 0x6e, 0x2f, 0x64, 0x65, 0x76, 0x2f, 0x6d, 0x2f, 0x64,
	0x65, 0x66, 0x6e, 0x2f, 0x64, 0x65, 0x76, 0x2f, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x2f,
	0x76, 0x31, 0x3b, 0x6c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x76, 0x31, 0xa2, 0x02, 0x03, 0x44,
	0x44, 0x4c, 0xaa, 0x02, 0x13, 0x44, 0x65, 0x66, 0x6e, 0x2e, 0x44, 0x65, 0x76, 0x2e, 0x4c, 0x65,
	0x67, 0x75, 0x6d, 0x65, 0x73, 0x2e, 0x56, 0x31, 0xca, 0x02, 0x13, 0x44, 0x65, 0x66, 0x6e, 0x5c,
	0x44, 0x65, 0x76, 0x5c, 0x4c, 0x65, 0x67, 0x75, 0x6d, 0x65, 0x73, 0x5c, 0x56, 0x31, 0xe2, 0x02,
	0x1f, 0x44, 0x65, 0x66, 0x6e, 0x5c, 0x44, 0x65, 0x76, 0x5c, 0x4c, 0x65, 0x67, 0x75, 0x6d, 0x65,
	0x73, 0x5c, 0x56, 0x31, 0x5c, 0x47, 0x50, 0x42, 0x4d, 0x65, 0x74, 0x61, 0x64, 0x61, 0x74, 0x61,
	0xea, 0x02, 0x16, 0x44, 0x65, 0x66, 0x6e, 0x3a, 0x3a, 0x44, 0x65, 0x76, 0x3a, 0x3a, 0x4c, 0x65,
	0x67, 0x75, 0x6d, 0x65, 0x73, 0x3a, 0x3a, 0x56, 0x31, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x33,
}

var (
	file_legumes_v1_pea_proto_rawDescOnce sync.Once
	file_legumes_v1_pea_proto_rawDescData = file_legumes_v1_pea_proto_rawDesc
)

func file_legumes_v1_pea_proto_rawDescGZIP() []byte {
	file_legumes_v1_pea_proto_rawDescOnce.Do(func() {
		file_legumes_v1_pea_proto_rawDescData = protoimpl.X.CompressGZIP(file_legumes_v1_pea_proto_rawDescData)
	})
	return file_legumes_v1_pea_proto_rawDescData
}

var file_legumes_v1_pea_proto_msgTypes = make([]protoimpl.MessageInfo, 7)
var file_legumes_v1_pea_proto_goTypes = []interface{}{
	(*Pea)(nil),               // 0: defn.dev.legumes.v1.Pea
	(*GetPeaRequest)(nil),     // 1: defn.dev.legumes.v1.GetPeaRequest
	(*GetPeaResponse)(nil),    // 2: defn.dev.legumes.v1.GetPeaResponse
	(*PutPeaRequest)(nil),     // 3: defn.dev.legumes.v1.PutPeaRequest
	(*PutPeaResponse)(nil),    // 4: defn.dev.legumes.v1.PutPeaResponse
	(*DeletePeaRequest)(nil),  // 5: defn.dev.legumes.v1.DeletePeaRequest
	(*DeletePeaResponse)(nil), // 6: defn.dev.legumes.v1.DeletePeaResponse
}
var file_legumes_v1_pea_proto_depIdxs = []int32{
	0, // 0: defn.dev.legumes.v1.GetPeaRequest.req:type_name -> defn.dev.legumes.v1.Pea
	0, // 1: defn.dev.legumes.v1.GetPeaResponse.req:type_name -> defn.dev.legumes.v1.Pea
	0, // 2: defn.dev.legumes.v1.PutPeaRequest.req:type_name -> defn.dev.legumes.v1.Pea
	0, // 3: defn.dev.legumes.v1.PutPeaResponse.req:type_name -> defn.dev.legumes.v1.Pea
	0, // 4: defn.dev.legumes.v1.DeletePeaRequest.req:type_name -> defn.dev.legumes.v1.Pea
	0, // 5: defn.dev.legumes.v1.DeletePeaResponse.req:type_name -> defn.dev.legumes.v1.Pea
	1, // 6: defn.dev.legumes.v1.PeaStoreService.GetPea:input_type -> defn.dev.legumes.v1.GetPeaRequest
	3, // 7: defn.dev.legumes.v1.PeaStoreService.PutPea:input_type -> defn.dev.legumes.v1.PutPeaRequest
	5, // 8: defn.dev.legumes.v1.PeaStoreService.DeletePea:input_type -> defn.dev.legumes.v1.DeletePeaRequest
	2, // 9: defn.dev.legumes.v1.PeaStoreService.GetPea:output_type -> defn.dev.legumes.v1.GetPeaResponse
	4, // 10: defn.dev.legumes.v1.PeaStoreService.PutPea:output_type -> defn.dev.legumes.v1.PutPeaResponse
	6, // 11: defn.dev.legumes.v1.PeaStoreService.DeletePea:output_type -> defn.dev.legumes.v1.DeletePeaResponse
	9, // [9:12] is the sub-list for method output_type
	6, // [6:9] is the sub-list for method input_type
	6, // [6:6] is the sub-list for extension type_name
	6, // [6:6] is the sub-list for extension extendee
	0, // [0:6] is the sub-list for field type_name
}

func init() { file_legumes_v1_pea_proto_init() }
func file_legumes_v1_pea_proto_init() {
	if File_legumes_v1_pea_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_legumes_v1_pea_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*Pea); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*GetPeaRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[2].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*GetPeaResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[3].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PutPeaRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[4].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PutPeaResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[5].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*DeletePeaRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_legumes_v1_pea_proto_msgTypes[6].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*DeletePeaResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_legumes_v1_pea_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   7,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_legumes_v1_pea_proto_goTypes,
		DependencyIndexes: file_legumes_v1_pea_proto_depIdxs,
		MessageInfos:      file_legumes_v1_pea_proto_msgTypes,
	}.Build()
	File_legumes_v1_pea_proto = out.File
	file_legumes_v1_pea_proto_rawDesc = nil
	file_legumes_v1_pea_proto_goTypes = nil
	file_legumes_v1_pea_proto_depIdxs = nil
}
