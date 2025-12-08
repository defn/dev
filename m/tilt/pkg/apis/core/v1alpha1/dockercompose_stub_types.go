/*
Stub types for docker-compose support that has been removed.
These types exist only to satisfy generated protobuf/deepcopy code.
They will be removed when regenerating the proto files.
*/
package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// DockerComposeLogStream - stub type (docker-compose support removed)
type DockerComposeLogStream struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
	Spec              DockerComposeLogStreamSpec   `json:"spec,omitempty" protobuf:"bytes,2,opt,name=spec"`
	Status            DockerComposeLogStreamStatus `json:"status,omitempty" protobuf:"bytes,3,opt,name=status"`
}

type DockerComposeLogStreamList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
	Items           []DockerComposeLogStream `json:"items" protobuf:"bytes,2,rep,name=items"`
}

type DockerComposeLogStreamSpec struct {
	Service string               `json:"service,omitempty" protobuf:"bytes,1,opt,name=service"`
	Project DockerComposeProject `json:"project,omitempty" protobuf:"bytes,2,opt,name=project"`
}

type DockerComposeLogStreamStatus struct {
	Error     string           `json:"error,omitempty" protobuf:"bytes,1,opt,name=error"`
	StartedAt metav1.MicroTime `json:"startedAt,omitempty" protobuf:"bytes,2,opt,name=startedAt"`
}

// DockerComposeService - stub type (docker-compose support removed)
type DockerComposeService struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
	Spec              DockerComposeServiceSpec   `json:"spec,omitempty" protobuf:"bytes,2,opt,name=spec"`
	Status            DockerComposeServiceStatus `json:"status,omitempty" protobuf:"bytes,3,opt,name=status"`
}

type DockerComposeServiceList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
	Items           []DockerComposeService `json:"items" protobuf:"bytes,2,rep,name=items"`
}

type DockerComposeServiceSpec struct {
	Service       string               `json:"service,omitempty" protobuf:"bytes,1,opt,name=service"`
	Project       DockerComposeProject `json:"project,omitempty" protobuf:"bytes,2,opt,name=project"`
	ImageMaps     []string             `json:"imageMaps,omitempty" protobuf:"bytes,3,rep,name=imageMaps"`
	DisableSource *DisableSource       `json:"disableSource,omitempty" protobuf:"bytes,4,opt,name=disableSource"`
}

type DockerComposeServiceStatus struct {
	DisableStatus      *DisableStatus        `json:"disableStatus,omitempty" protobuf:"bytes,1,opt,name=disableStatus"`
	ContainerState     *DockerContainerState `json:"containerState,omitempty" protobuf:"bytes,2,opt,name=containerState"`
	PortBindings       []DockerPortBinding   `json:"portBindings,omitempty" protobuf:"bytes,3,rep,name=portBindings"`
	ContainerID        string                `json:"containerID,omitempty" protobuf:"bytes,4,opt,name=containerID"`
	ContainerName      string                `json:"containerName,omitempty" protobuf:"bytes,5,opt,name=containerName"`
	ApplyError         string                `json:"applyError,omitempty" protobuf:"bytes,6,opt,name=applyError"`
	LastApplyStartTime metav1.MicroTime      `json:"lastApplyStartTime,omitempty" protobuf:"bytes,7,opt,name=lastApplyStartTime"`
	LastApplyFinishTime metav1.MicroTime     `json:"lastApplyFinishTime,omitempty" protobuf:"bytes,8,opt,name=lastApplyFinishTime"`
}

type DockerComposeProject struct {
	ConfigPaths []string `json:"configPaths,omitempty" protobuf:"bytes,1,rep,name=configPaths"`
	Name        string   `json:"name,omitempty" protobuf:"bytes,2,opt,name=name"`
	YAML        string   `json:"yaml,omitempty" protobuf:"bytes,3,opt,name=yaml"`
	EnvFile     string   `json:"envFile,omitempty" protobuf:"bytes,4,opt,name=envFile"`
	Profiles    []string `json:"profiles,omitempty" protobuf:"bytes,5,rep,name=profiles"`
	ProjectPath string   `json:"projectPath,omitempty" protobuf:"bytes,6,opt,name=projectPath"`
	Wait        bool     `json:"wait,omitempty" protobuf:"varint,7,opt,name=wait"`
}

type DockerContainerState struct {
	ContainerID  string           `json:"containerID,omitempty" protobuf:"bytes,1,opt,name=containerID"`
	Status       string           `json:"status,omitempty" protobuf:"bytes,2,opt,name=status"`
	Running      bool             `json:"running,omitempty" protobuf:"varint,3,opt,name=running"`
	Error        string           `json:"error,omitempty" protobuf:"bytes,4,opt,name=error"`
	StartedAt    metav1.MicroTime `json:"startedAt,omitempty" protobuf:"bytes,5,opt,name=startedAt"`
	FinishedAt   metav1.MicroTime `json:"finishedAt,omitempty" protobuf:"bytes,6,opt,name=finishedAt"`
	HealthStatus string           `json:"healthStatus,omitempty" protobuf:"bytes,7,opt,name=healthStatus"`
	ExitCode     int32            `json:"exitCode,omitempty" protobuf:"varint,8,opt,name=exitCode"`
}

type DockerPortBinding struct {
	ContainerPort int32  `json:"containerPort,omitempty" protobuf:"varint,1,opt,name=containerPort"`
	HostIP        string `json:"hostIP,omitempty" protobuf:"bytes,2,opt,name=hostIP"`
	HostPort      int32  `json:"hostPort,omitempty" protobuf:"varint,3,opt,name=hostPort"`
}

type LiveUpdateDockerComposeSelector struct {
	Service   string `json:"service,omitempty" protobuf:"bytes,1,opt,name=service"`
	Container string `json:"container,omitempty" protobuf:"bytes,2,opt,name=container"`
}

