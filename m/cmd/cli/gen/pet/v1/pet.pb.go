// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.30.0
// 	protoc        (unknown)
// source: pet/v1/pet.proto

package petv1

import (
	_type "github.com/defn/dev/m/cmd/cli/gen/google/type"
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

// PetType represents the different types of pets in the pet store.
type PetType int32

const (
	PetType_PET_TYPE_UNSPECIFIED PetType = 0
	PetType_PET_TYPE_CAT         PetType = 1
	PetType_PET_TYPE_DOG         PetType = 2
	PetType_PET_TYPE_SNAKE       PetType = 3
	PetType_PET_TYPE_HAMSTER     PetType = 4
)

// Enum value maps for PetType.
var (
	PetType_name = map[int32]string{
		0: "PET_TYPE_UNSPECIFIED",
		1: "PET_TYPE_CAT",
		2: "PET_TYPE_DOG",
		3: "PET_TYPE_SNAKE",
		4: "PET_TYPE_HAMSTER",
	}
	PetType_value = map[string]int32{
		"PET_TYPE_UNSPECIFIED": 0,
		"PET_TYPE_CAT":         1,
		"PET_TYPE_DOG":         2,
		"PET_TYPE_SNAKE":       3,
		"PET_TYPE_HAMSTER":     4,
	}
)

func (x PetType) Enum() *PetType {
	p := new(PetType)
	*p = x
	return p
}

func (x PetType) String() string {
	return protoimpl.X.EnumStringOf(x.Descriptor(), protoreflect.EnumNumber(x))
}

func (PetType) Descriptor() protoreflect.EnumDescriptor {
	return file_pet_v1_pet_proto_enumTypes[0].Descriptor()
}

func (PetType) Type() protoreflect.EnumType {
	return &file_pet_v1_pet_proto_enumTypes[0]
}

func (x PetType) Number() protoreflect.EnumNumber {
	return protoreflect.EnumNumber(x)
}

// Deprecated: Use PetType.Descriptor instead.
func (PetType) EnumDescriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{0}
}

// Pet represents a pet in the pet store.
type Pet struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	PetType   PetType         `protobuf:"varint,1,opt,name=pet_type,json=petType,proto3,enum=pet.v1.PetType" json:"pet_type,omitempty"`
	PetId     string          `protobuf:"bytes,2,opt,name=pet_id,json=petId,proto3" json:"pet_id,omitempty"`
	Name      string          `protobuf:"bytes,3,opt,name=name,proto3" json:"name,omitempty"`
	CreatedAt *_type.DateTime `protobuf:"bytes,4,opt,name=created_at,json=createdAt,proto3" json:"created_at,omitempty"`
}

func (x *Pet) Reset() {
	*x = Pet{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Pet) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Pet) ProtoMessage() {}

func (x *Pet) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Pet.ProtoReflect.Descriptor instead.
func (*Pet) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{0}
}

func (x *Pet) GetPetType() PetType {
	if x != nil {
		return x.PetType
	}
	return PetType_PET_TYPE_UNSPECIFIED
}

func (x *Pet) GetPetId() string {
	if x != nil {
		return x.PetId
	}
	return ""
}

func (x *Pet) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *Pet) GetCreatedAt() *_type.DateTime {
	if x != nil {
		return x.CreatedAt
	}
	return nil
}

type GetPetRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	PetId string `protobuf:"bytes,1,opt,name=pet_id,json=petId,proto3" json:"pet_id,omitempty"`
}

func (x *GetPetRequest) Reset() {
	*x = GetPetRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetPetRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetPetRequest) ProtoMessage() {}

func (x *GetPetRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetPetRequest.ProtoReflect.Descriptor instead.
func (*GetPetRequest) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{1}
}

func (x *GetPetRequest) GetPetId() string {
	if x != nil {
		return x.PetId
	}
	return ""
}

type GetPetResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Pet *Pet `protobuf:"bytes,1,opt,name=pet,proto3" json:"pet,omitempty"`
}

func (x *GetPetResponse) Reset() {
	*x = GetPetResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetPetResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetPetResponse) ProtoMessage() {}

func (x *GetPetResponse) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetPetResponse.ProtoReflect.Descriptor instead.
func (*GetPetResponse) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{2}
}

func (x *GetPetResponse) GetPet() *Pet {
	if x != nil {
		return x.Pet
	}
	return nil
}

type PutPetRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	PetType PetType `protobuf:"varint,1,opt,name=pet_type,json=petType,proto3,enum=pet.v1.PetType" json:"pet_type,omitempty"`
	Name    string  `protobuf:"bytes,2,opt,name=name,proto3" json:"name,omitempty"`
}

func (x *PutPetRequest) Reset() {
	*x = PutPetRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[3]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PutPetRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PutPetRequest) ProtoMessage() {}

func (x *PutPetRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[3]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PutPetRequest.ProtoReflect.Descriptor instead.
func (*PutPetRequest) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{3}
}

func (x *PutPetRequest) GetPetType() PetType {
	if x != nil {
		return x.PetType
	}
	return PetType_PET_TYPE_UNSPECIFIED
}

func (x *PutPetRequest) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

type PutPetResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Pet *Pet `protobuf:"bytes,1,opt,name=pet,proto3" json:"pet,omitempty"`
}

func (x *PutPetResponse) Reset() {
	*x = PutPetResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[4]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PutPetResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PutPetResponse) ProtoMessage() {}

func (x *PutPetResponse) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[4]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PutPetResponse.ProtoReflect.Descriptor instead.
func (*PutPetResponse) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{4}
}

func (x *PutPetResponse) GetPet() *Pet {
	if x != nil {
		return x.Pet
	}
	return nil
}

type DeletePetRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	PetId string `protobuf:"bytes,1,opt,name=pet_id,json=petId,proto3" json:"pet_id,omitempty"`
}

func (x *DeletePetRequest) Reset() {
	*x = DeletePetRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[5]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DeletePetRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DeletePetRequest) ProtoMessage() {}

func (x *DeletePetRequest) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[5]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DeletePetRequest.ProtoReflect.Descriptor instead.
func (*DeletePetRequest) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{5}
}

func (x *DeletePetRequest) GetPetId() string {
	if x != nil {
		return x.PetId
	}
	return ""
}

type DeletePetResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *DeletePetResponse) Reset() {
	*x = DeletePetResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_pet_v1_pet_proto_msgTypes[6]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DeletePetResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DeletePetResponse) ProtoMessage() {}

func (x *DeletePetResponse) ProtoReflect() protoreflect.Message {
	mi := &file_pet_v1_pet_proto_msgTypes[6]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DeletePetResponse.ProtoReflect.Descriptor instead.
func (*DeletePetResponse) Descriptor() ([]byte, []int) {
	return file_pet_v1_pet_proto_rawDescGZIP(), []int{6}
}

var File_pet_v1_pet_proto protoreflect.FileDescriptor

var file_pet_v1_pet_proto_rawDesc = []byte{
	0x0a, 0x10, 0x70, 0x65, 0x74, 0x2f, 0x76, 0x31, 0x2f, 0x70, 0x65, 0x74, 0x2e, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x12, 0x06, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x1a, 0x1a, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2f, 0x74, 0x79, 0x70, 0x65, 0x2f, 0x64, 0x61, 0x74, 0x65, 0x74, 0x69, 0x6d, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x92, 0x01, 0x0a, 0x03, 0x50, 0x65, 0x74, 0x12, 0x2a,
	0x0a, 0x08, 0x70, 0x65, 0x74, 0x5f, 0x74, 0x79, 0x70, 0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0e,
	0x32, 0x0f, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x74, 0x54, 0x79, 0x70,
	0x65, 0x52, 0x07, 0x70, 0x65, 0x74, 0x54, 0x79, 0x70, 0x65, 0x12, 0x15, 0x0a, 0x06, 0x70, 0x65,
	0x74, 0x5f, 0x69, 0x64, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x05, 0x70, 0x65, 0x74, 0x49,
	0x64, 0x12, 0x12, 0x0a, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x18, 0x03, 0x20, 0x01, 0x28, 0x09, 0x52,
	0x04, 0x6e, 0x61, 0x6d, 0x65, 0x12, 0x34, 0x0a, 0x0a, 0x63, 0x72, 0x65, 0x61, 0x74, 0x65, 0x64,
	0x5f, 0x61, 0x74, 0x18, 0x04, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x15, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x74, 0x79, 0x70, 0x65, 0x2e, 0x44, 0x61, 0x74, 0x65, 0x54, 0x69, 0x6d, 0x65,
	0x52, 0x09, 0x63, 0x72, 0x65, 0x61, 0x74, 0x65, 0x64, 0x41, 0x74, 0x22, 0x26, 0x0a, 0x0d, 0x47,
	0x65, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x15, 0x0a, 0x06,
	0x70, 0x65, 0x74, 0x5f, 0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x05, 0x70, 0x65,
	0x74, 0x49, 0x64, 0x22, 0x2f, 0x0a, 0x0e, 0x47, 0x65, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65, 0x73,
	0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x1d, 0x0a, 0x03, 0x70, 0x65, 0x74, 0x18, 0x01, 0x20, 0x01,
	0x28, 0x0b, 0x32, 0x0b, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65, 0x74, 0x52,
	0x03, 0x70, 0x65, 0x74, 0x22, 0x4f, 0x0a, 0x0d, 0x50, 0x75, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65,
	0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x2a, 0x0a, 0x08, 0x70, 0x65, 0x74, 0x5f, 0x74, 0x79, 0x70,
	0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0e, 0x32, 0x0f, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31,
	0x2e, 0x50, 0x65, 0x74, 0x54, 0x79, 0x70, 0x65, 0x52, 0x07, 0x70, 0x65, 0x74, 0x54, 0x79, 0x70,
	0x65, 0x12, 0x12, 0x0a, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52,
	0x04, 0x6e, 0x61, 0x6d, 0x65, 0x22, 0x2f, 0x0a, 0x0e, 0x50, 0x75, 0x74, 0x50, 0x65, 0x74, 0x52,
	0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12, 0x1d, 0x0a, 0x03, 0x70, 0x65, 0x74, 0x18, 0x01,
	0x20, 0x01, 0x28, 0x0b, 0x32, 0x0b, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x65,
	0x74, 0x52, 0x03, 0x70, 0x65, 0x74, 0x22, 0x29, 0x0a, 0x10, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65,
	0x50, 0x65, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x15, 0x0a, 0x06, 0x70, 0x65,
	0x74, 0x5f, 0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x05, 0x70, 0x65, 0x74, 0x49,
	0x64, 0x22, 0x13, 0x0a, 0x11, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x74, 0x52, 0x65,
	0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x2a, 0x71, 0x0a, 0x07, 0x50, 0x65, 0x74, 0x54, 0x79, 0x70,
	0x65, 0x12, 0x18, 0x0a, 0x14, 0x50, 0x45, 0x54, 0x5f, 0x54, 0x59, 0x50, 0x45, 0x5f, 0x55, 0x4e,
	0x53, 0x50, 0x45, 0x43, 0x49, 0x46, 0x49, 0x45, 0x44, 0x10, 0x00, 0x12, 0x10, 0x0a, 0x0c, 0x50,
	0x45, 0x54, 0x5f, 0x54, 0x59, 0x50, 0x45, 0x5f, 0x43, 0x41, 0x54, 0x10, 0x01, 0x12, 0x10, 0x0a,
	0x0c, 0x50, 0x45, 0x54, 0x5f, 0x54, 0x59, 0x50, 0x45, 0x5f, 0x44, 0x4f, 0x47, 0x10, 0x02, 0x12,
	0x12, 0x0a, 0x0e, 0x50, 0x45, 0x54, 0x5f, 0x54, 0x59, 0x50, 0x45, 0x5f, 0x53, 0x4e, 0x41, 0x4b,
	0x45, 0x10, 0x03, 0x12, 0x14, 0x0a, 0x10, 0x50, 0x45, 0x54, 0x5f, 0x54, 0x59, 0x50, 0x45, 0x5f,
	0x48, 0x41, 0x4d, 0x53, 0x54, 0x45, 0x52, 0x10, 0x04, 0x32, 0xcb, 0x01, 0x0a, 0x0f, 0x50, 0x65,
	0x74, 0x53, 0x74, 0x6f, 0x72, 0x65, 0x53, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x12, 0x39, 0x0a,
	0x06, 0x47, 0x65, 0x74, 0x50, 0x65, 0x74, 0x12, 0x15, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31,
	0x2e, 0x47, 0x65, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x16,
	0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x47, 0x65, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65,
	0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12, 0x39, 0x0a, 0x06, 0x50, 0x75, 0x74, 0x50,
	0x65, 0x74, 0x12, 0x15, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x50, 0x75, 0x74, 0x50,
	0x65, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x16, 0x2e, 0x70, 0x65, 0x74, 0x2e,
	0x76, 0x31, 0x2e, 0x50, 0x75, 0x74, 0x50, 0x65, 0x74, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73,
	0x65, 0x22, 0x00, 0x12, 0x42, 0x0a, 0x09, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x74,
	0x12, 0x18, 0x2e, 0x70, 0x65, 0x74, 0x2e, 0x76, 0x31, 0x2e, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65,
	0x50, 0x65, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x19, 0x2e, 0x70, 0x65, 0x74,
	0x2e, 0x76, 0x31, 0x2e, 0x44, 0x65, 0x6c, 0x65, 0x74, 0x65, 0x50, 0x65, 0x74, 0x52, 0x65, 0x73,
	0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x42, 0x7b, 0x0a, 0x0a, 0x63, 0x6f, 0x6d, 0x2e, 0x70,
	0x65, 0x74, 0x2e, 0x76, 0x31, 0x42, 0x08, 0x50, 0x65, 0x74, 0x50, 0x72, 0x6f, 0x74, 0x6f, 0x50,
	0x01, 0x5a, 0x2a, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x64, 0x65,
	0x66, 0x6e, 0x2f, 0x6d, 0x2f, 0x63, 0x6d, 0x64, 0x2f, 0x63, 0x6c, 0x69, 0x2f, 0x67, 0x65, 0x6e,
	0x2f, 0x70, 0x65, 0x74, 0x2f, 0x76, 0x31, 0x3b, 0x70, 0x65, 0x74, 0x76, 0x31, 0xa2, 0x02, 0x03,
	0x50, 0x58, 0x58, 0xaa, 0x02, 0x06, 0x50, 0x65, 0x74, 0x2e, 0x56, 0x31, 0xca, 0x02, 0x06, 0x50,
	0x65, 0x74, 0x5c, 0x56, 0x31, 0xe2, 0x02, 0x12, 0x50, 0x65, 0x74, 0x5c, 0x56, 0x31, 0x5c, 0x47,
	0x50, 0x42, 0x4d, 0x65, 0x74, 0x61, 0x64, 0x61, 0x74, 0x61, 0xea, 0x02, 0x07, 0x50, 0x65, 0x74,
	0x3a, 0x3a, 0x56, 0x31, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_pet_v1_pet_proto_rawDescOnce sync.Once
	file_pet_v1_pet_proto_rawDescData = file_pet_v1_pet_proto_rawDesc
)

func file_pet_v1_pet_proto_rawDescGZIP() []byte {
	file_pet_v1_pet_proto_rawDescOnce.Do(func() {
		file_pet_v1_pet_proto_rawDescData = protoimpl.X.CompressGZIP(file_pet_v1_pet_proto_rawDescData)
	})
	return file_pet_v1_pet_proto_rawDescData
}

var file_pet_v1_pet_proto_enumTypes = make([]protoimpl.EnumInfo, 1)
var file_pet_v1_pet_proto_msgTypes = make([]protoimpl.MessageInfo, 7)
var file_pet_v1_pet_proto_goTypes = []interface{}{
	(PetType)(0),              // 0: pet.v1.PetType
	(*Pet)(nil),               // 1: pet.v1.Pet
	(*GetPetRequest)(nil),     // 2: pet.v1.GetPetRequest
	(*GetPetResponse)(nil),    // 3: pet.v1.GetPetResponse
	(*PutPetRequest)(nil),     // 4: pet.v1.PutPetRequest
	(*PutPetResponse)(nil),    // 5: pet.v1.PutPetResponse
	(*DeletePetRequest)(nil),  // 6: pet.v1.DeletePetRequest
	(*DeletePetResponse)(nil), // 7: pet.v1.DeletePetResponse
	(*_type.DateTime)(nil),    // 8: google.type.DateTime
}
var file_pet_v1_pet_proto_depIdxs = []int32{
	0, // 0: pet.v1.Pet.pet_type:type_name -> pet.v1.PetType
	8, // 1: pet.v1.Pet.created_at:type_name -> google.type.DateTime
	1, // 2: pet.v1.GetPetResponse.pet:type_name -> pet.v1.Pet
	0, // 3: pet.v1.PutPetRequest.pet_type:type_name -> pet.v1.PetType
	1, // 4: pet.v1.PutPetResponse.pet:type_name -> pet.v1.Pet
	2, // 5: pet.v1.PetStoreService.GetPet:input_type -> pet.v1.GetPetRequest
	4, // 6: pet.v1.PetStoreService.PutPet:input_type -> pet.v1.PutPetRequest
	6, // 7: pet.v1.PetStoreService.DeletePet:input_type -> pet.v1.DeletePetRequest
	3, // 8: pet.v1.PetStoreService.GetPet:output_type -> pet.v1.GetPetResponse
	5, // 9: pet.v1.PetStoreService.PutPet:output_type -> pet.v1.PutPetResponse
	7, // 10: pet.v1.PetStoreService.DeletePet:output_type -> pet.v1.DeletePetResponse
	8, // [8:11] is the sub-list for method output_type
	5, // [5:8] is the sub-list for method input_type
	5, // [5:5] is the sub-list for extension type_name
	5, // [5:5] is the sub-list for extension extendee
	0, // [0:5] is the sub-list for field type_name
}

func init() { file_pet_v1_pet_proto_init() }
func file_pet_v1_pet_proto_init() {
	if File_pet_v1_pet_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_pet_v1_pet_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*Pet); i {
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
		file_pet_v1_pet_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*GetPetRequest); i {
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
		file_pet_v1_pet_proto_msgTypes[2].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*GetPetResponse); i {
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
		file_pet_v1_pet_proto_msgTypes[3].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PutPetRequest); i {
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
		file_pet_v1_pet_proto_msgTypes[4].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PutPetResponse); i {
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
		file_pet_v1_pet_proto_msgTypes[5].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*DeletePetRequest); i {
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
		file_pet_v1_pet_proto_msgTypes[6].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*DeletePetResponse); i {
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
			RawDescriptor: file_pet_v1_pet_proto_rawDesc,
			NumEnums:      1,
			NumMessages:   7,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_pet_v1_pet_proto_goTypes,
		DependencyIndexes: file_pet_v1_pet_proto_depIdxs,
		EnumInfos:         file_pet_v1_pet_proto_enumTypes,
		MessageInfos:      file_pet_v1_pet_proto_msgTypes,
	}.Build()
	File_pet_v1_pet_proto = out.File
	file_pet_v1_pet_proto_rawDesc = nil
	file_pet_v1_pet_proto_goTypes = nil
	file_pet_v1_pet_proto_depIdxs = nil
}
