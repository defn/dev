package v1alpha1

import (
	"fmt"
	"time"

	"go.starlark.net/starlark"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"
	"github.com/defn/dev/m/tilt/internal/tiltfile/value"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// MODIFIED: Simplified to remove K8s-specific types

func (p Plugin) registerSymbols(env *starkit.Environment) error {
	var err error

	err = env.AddBuiltin("v1alpha1.cmd", p.cmd)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.config_map", p.configMap)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.extension", p.extension)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.extension_repo", p.extensionRepo)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.file_watch", p.fileWatch)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_button", p.uiButton)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.config_map_disable_source", p.configMapDisableSource)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.disable_source", p.disableSource)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.exec_action", p.execAction)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.http_get_action", p.hTTPGetAction)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.http_header", p.hTTPHeader)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.handler", p.handler)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ignore_def", p.ignoreDef)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.probe", p.probe)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.restart_on_spec", p.restartOnSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.start_on_spec", p.startOnSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.tcp_socket_action", p.tCPSocketAction)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_bool_input_spec", p.uIBoolInputSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_choice_input_spec", p.uIChoiceInputSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_component_location", p.uIComponentLocation)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_hidden_input_spec", p.uIHiddenInputSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_input_spec", p.uIInputSpec)
	if err != nil {
		return err
	}
	err = env.AddBuiltin("v1alpha1.ui_text_input_spec", p.uITextInputSpec)
	if err != nil {
		return err
	}
	return nil
}

func (p Plugin) cmd(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.Cmd{
		ObjectMeta: metav1.ObjectMeta{},
		Spec:       v1alpha1.CmdSpec{},
	}
	var specArgs value.StringList
	var dir value.LocalPath = value.NewLocalPathUnpacker(t)
	err = dir.Unpack(starlark.String(""))
	if err != nil {
		return nil, err
	}

	var env value.StringList
	var readinessProbe Probe = Probe{t: t}
	var restartOn RestartOnSpec = RestartOnSpec{t: t}
	var startOn StartOnSpec = StartOnSpec{t: t}
	var disableSource DisableSource = DisableSource{t: t}
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"args?", &specArgs,
		"dir?", &dir,
		"env?", &env,
		"readiness_probe?", &readinessProbe,
		"restart_on?", &restartOn,
		"start_on?", &startOn,
		"disable_source?", &disableSource,
	)
	if err != nil {
		return nil, err
	}

	obj.Spec.Args = specArgs
	obj.Spec.Dir = dir.Value
	obj.Spec.Env = env
	if readinessProbe.isUnpacked {
		obj.Spec.ReadinessProbe = (*v1alpha1.Probe)(&readinessProbe.Value)
	}
	if restartOn.isUnpacked {
		obj.Spec.RestartOn = (*v1alpha1.RestartOnSpec)(&restartOn.Value)
	}
	if startOn.isUnpacked {
		obj.Spec.StartOn = (*v1alpha1.StartOnSpec)(&startOn.Value)
	}
	if disableSource.isUnpacked {
		obj.Spec.DisableSource = (*v1alpha1.DisableSource)(&disableSource.Value)
	}
	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

func (p Plugin) configMap(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{},
	}
	var data value.StringStringMap
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"data?", &data,
	)
	if err != nil {
		return nil, err
	}

	obj.Data = data
	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

func (p Plugin) extension(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.Extension{
		ObjectMeta: metav1.ObjectMeta{},
		Spec:       v1alpha1.ExtensionSpec{},
	}
	var specArgs value.StringList
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"repo_name?", &obj.Spec.RepoName,
		"repo_path?", &obj.Spec.RepoPath,
		"args?", &specArgs,
	)
	if err != nil {
		return nil, err
	}

	obj.Spec.Args = specArgs
	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

func (p Plugin) extensionRepo(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.ExtensionRepo{
		ObjectMeta: metav1.ObjectMeta{},
		Spec:       v1alpha1.ExtensionRepoSpec{},
	}
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"url?", &obj.Spec.URL,
		"ref?", &obj.Spec.Ref,
		"load_host?", &obj.Spec.LoadHost,
		"git_subpath?", &obj.Spec.GitSubpath,
	)
	if err != nil {
		return nil, err
	}

	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

func (p Plugin) fileWatch(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.FileWatch{
		ObjectMeta: metav1.ObjectMeta{},
		Spec:       v1alpha1.FileWatchSpec{},
	}
	var watchedPaths value.LocalPathList = value.NewLocalPathListUnpacker(t)
	var ignores IgnoreDefList = IgnoreDefList{t: t}
	var disableSource DisableSource = DisableSource{t: t}
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"watched_paths?", &watchedPaths,
		"ignores?", &ignores,
		"disable_source?", &disableSource,
	)
	if err != nil {
		return nil, err
	}

	obj.Spec.WatchedPaths = watchedPaths.Value
	obj.Spec.Ignores = ignores.Value
	if disableSource.isUnpacked {
		obj.Spec.DisableSource = (*v1alpha1.DisableSource)(&disableSource.Value)
	}
	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

func (p Plugin) uiButton(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var err error
	obj := &v1alpha1.UIButton{
		ObjectMeta: metav1.ObjectMeta{},
		Spec:       v1alpha1.UIButtonSpec{},
	}
	var location UIComponentLocation = UIComponentLocation{t: t}
	var inputs UIInputSpecList = UIInputSpecList{t: t}
	var labels value.StringStringMap
	var annotations value.StringStringMap
	err = starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name", &obj.ObjectMeta.Name,
		"labels?", &labels,
		"annotations?", &annotations,
		"text?", &obj.Spec.Text,
		"icon_name?", &obj.Spec.IconName,
		"icon_svg?", &obj.Spec.IconSVG,
		"location?", &location,
		"inputs?", &inputs,
		"disabled?", &obj.Spec.Disabled,
		"requires_confirmation?", &obj.Spec.RequiresConfirmation,
	)
	if err != nil {
		return nil, err
	}

	if location.isUnpacked {
		obj.Spec.Location = v1alpha1.UIComponentLocation(location.Value)
	}
	obj.Spec.Inputs = inputs.Value
	obj.ObjectMeta.Labels = labels
	obj.ObjectMeta.Annotations = annotations
	return p.register(t, obj)
}

// ConfigMapDisableSource type
type ConfigMapDisableSource struct {
	*starlark.Dict
	Value      v1alpha1.ConfigMapDisableSource
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) configMapDisableSource(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var name starlark.Value
	var key starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name?", &name,
		"key?", &key,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if name != nil {
		err := dict.SetKey(starlark.String("name"), name)
		if err != nil {
			return nil, err
		}
	}
	if key != nil {
		err := dict.SetKey(starlark.String("key"), key)
		if err != nil {
			return nil, err
		}
	}
	var obj *ConfigMapDisableSource = &ConfigMapDisableSource{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *ConfigMapDisableSource) Unpack(v starlark.Value) error {
	obj := v1alpha1.ConfigMapDisableSource{}

	starlarkObj, ok := v.(*ConfigMapDisableSource)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "name" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Name = v
			continue
		}
		if key == "key" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Key = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// DisableSource type
type DisableSource struct {
	*starlark.Dict
	Value      v1alpha1.DisableSource
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) disableSource(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var everyConfigMap starlark.Value
	var configMap starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"every_config_map?", &everyConfigMap,
		"config_map?", &configMap,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if everyConfigMap != nil {
		err := dict.SetKey(starlark.String("every_config_map"), everyConfigMap)
		if err != nil {
			return nil, err
		}
	}
	if configMap != nil {
		err := dict.SetKey(starlark.String("config_map"), configMap)
		if err != nil {
			return nil, err
		}
	}
	var obj *DisableSource = &DisableSource{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *DisableSource) Unpack(v starlark.Value) error {
	obj := v1alpha1.DisableSource{}

	starlarkObj, ok := v.(*DisableSource)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "every_config_map" {
			var v ConfigMapDisableSourceList
			v.t = o.t
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.EveryConfigMap = v.Value
			continue
		}
		if key == "config_map" {
			v := ConfigMapDisableSource{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.ConfigMap = (*v1alpha1.ConfigMapDisableSource)(&v.Value)
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

type ConfigMapDisableSourceList struct {
	*starlark.List
	Value []v1alpha1.ConfigMapDisableSource
	t     *starlark.Thread
}

func (o *ConfigMapDisableSourceList) Unpack(v starlark.Value) error {
	items := []v1alpha1.ConfigMapDisableSource{}

	listObj, ok := v.(*starlark.List)
	if !ok {
		return fmt.Errorf("expected list, actual: %v", v.Type())
	}

	for i := 0; i < listObj.Len(); i++ {
		v := listObj.Index(i)
		item := ConfigMapDisableSource{t: o.t}
		err := item.Unpack(v)
		if err != nil {
			return fmt.Errorf("at index %d: %v", i, err)
		}
		items = append(items, v1alpha1.ConfigMapDisableSource(item.Value))
	}

	listObj.Freeze()
	o.List = listObj
	o.Value = items

	return nil
}

// ExecAction type
type ExecAction struct {
	*starlark.Dict
	Value      v1alpha1.ExecAction
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) execAction(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var command starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"command?", &command,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(1)
	if command != nil {
		err := dict.SetKey(starlark.String("command"), command)
		if err != nil {
			return nil, err
		}
	}
	var obj *ExecAction = &ExecAction{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *ExecAction) Unpack(v starlark.Value) error {
	obj := v1alpha1.ExecAction{}

	starlarkObj, ok := v.(*ExecAction)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "command" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Command = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// HTTPGetAction type
type HTTPGetAction struct {
	*starlark.Dict
	Value      v1alpha1.HTTPGetAction
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) hTTPGetAction(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var path starlark.Value
	var port starlark.Value
	var host starlark.Value
	var scheme starlark.Value
	var httpHeaders starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"path?", &path,
		"port?", &port,
		"host?", &host,
		"scheme?", &scheme,
		"http_headers?", &httpHeaders,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(5)
	if path != nil {
		err := dict.SetKey(starlark.String("path"), path)
		if err != nil {
			return nil, err
		}
	}
	if port != nil {
		err := dict.SetKey(starlark.String("port"), port)
		if err != nil {
			return nil, err
		}
	}
	if host != nil {
		err := dict.SetKey(starlark.String("host"), host)
		if err != nil {
			return nil, err
		}
	}
	if scheme != nil {
		err := dict.SetKey(starlark.String("scheme"), scheme)
		if err != nil {
			return nil, err
		}
	}
	if httpHeaders != nil {
		err := dict.SetKey(starlark.String("http_headers"), httpHeaders)
		if err != nil {
			return nil, err
		}
	}
	var obj *HTTPGetAction = &HTTPGetAction{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *HTTPGetAction) Unpack(v starlark.Value) error {
	obj := v1alpha1.HTTPGetAction{}

	starlarkObj, ok := v.(*HTTPGetAction)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "path" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Path = v
			continue
		}
		if key == "port" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.Port = int32(i)
			continue
		}
		if key == "host" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Host = v
			continue
		}
		if key == "scheme" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Scheme = v1alpha1.URIScheme(v)
			continue
		}
		if key == "http_headers" {
			var v HTTPHeaderList
			v.t = o.t
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.HTTPHeaders = v.Value
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// HTTPHeader type
type HTTPHeader struct {
	*starlark.Dict
	Value      v1alpha1.HTTPHeader
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) hTTPHeader(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var name starlark.Value
	var value starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name?", &name,
		"value?", &value,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if name != nil {
		err := dict.SetKey(starlark.String("name"), name)
		if err != nil {
			return nil, err
		}
	}
	if value != nil {
		err := dict.SetKey(starlark.String("value"), value)
		if err != nil {
			return nil, err
		}
	}
	var obj *HTTPHeader = &HTTPHeader{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *HTTPHeader) Unpack(v starlark.Value) error {
	obj := v1alpha1.HTTPHeader{}

	starlarkObj, ok := v.(*HTTPHeader)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "name" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Name = v
			continue
		}
		if key == "value" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Value = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

type HTTPHeaderList struct {
	*starlark.List
	Value []v1alpha1.HTTPHeader
	t     *starlark.Thread
}

func (o *HTTPHeaderList) Unpack(v starlark.Value) error {
	items := []v1alpha1.HTTPHeader{}

	listObj, ok := v.(*starlark.List)
	if !ok {
		return fmt.Errorf("expected list, actual: %v", v.Type())
	}

	for i := 0; i < listObj.Len(); i++ {
		v := listObj.Index(i)
		item := HTTPHeader{t: o.t}
		err := item.Unpack(v)
		if err != nil {
			return fmt.Errorf("at index %d: %v", i, err)
		}
		items = append(items, v1alpha1.HTTPHeader(item.Value))
	}

	listObj.Freeze()
	o.List = listObj
	o.Value = items

	return nil
}

// Handler type
type Handler struct {
	*starlark.Dict
	Value      v1alpha1.Handler
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) handler(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var exec starlark.Value
	var httpGet starlark.Value
	var tcpSocket starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"exec?", &exec,
		"http_get?", &httpGet,
		"tcp_socket?", &tcpSocket,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(3)
	if exec != nil {
		err := dict.SetKey(starlark.String("exec"), exec)
		if err != nil {
			return nil, err
		}
	}
	if httpGet != nil {
		err := dict.SetKey(starlark.String("http_get"), httpGet)
		if err != nil {
			return nil, err
		}
	}
	if tcpSocket != nil {
		err := dict.SetKey(starlark.String("tcp_socket"), tcpSocket)
		if err != nil {
			return nil, err
		}
	}
	var obj *Handler = &Handler{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *Handler) Unpack(v starlark.Value) error {
	obj := v1alpha1.Handler{}

	starlarkObj, ok := v.(*Handler)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "exec" {
			v := ExecAction{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Exec = (*v1alpha1.ExecAction)(&v.Value)
			continue
		}
		if key == "http_get" {
			v := HTTPGetAction{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.HTTPGet = (*v1alpha1.HTTPGetAction)(&v.Value)
			continue
		}
		if key == "tcp_socket" {
			v := TCPSocketAction{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.TCPSocket = (*v1alpha1.TCPSocketAction)(&v.Value)
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// IgnoreDef type
type IgnoreDef struct {
	*starlark.Dict
	Value      v1alpha1.IgnoreDef
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) ignoreDef(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var basePath starlark.Value
	var patterns starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"base_path?", &basePath,
		"patterns?", &patterns,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if basePath != nil {
		err := dict.SetKey(starlark.String("base_path"), basePath)
		if err != nil {
			return nil, err
		}
	}
	if patterns != nil {
		err := dict.SetKey(starlark.String("patterns"), patterns)
		if err != nil {
			return nil, err
		}
	}
	var obj *IgnoreDef = &IgnoreDef{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *IgnoreDef) Unpack(v starlark.Value) error {
	obj := v1alpha1.IgnoreDef{}

	starlarkObj, ok := v.(*IgnoreDef)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "base_path" {
			v := value.NewLocalPathUnpacker(o.t)
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.BasePath = v.Value
			continue
		}
		if key == "patterns" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Patterns = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

type IgnoreDefList struct {
	*starlark.List
	Value []v1alpha1.IgnoreDef
	t     *starlark.Thread
}

func (o *IgnoreDefList) Unpack(v starlark.Value) error {
	items := []v1alpha1.IgnoreDef{}

	listObj, ok := v.(*starlark.List)
	if !ok {
		return fmt.Errorf("expected list, actual: %v", v.Type())
	}

	for i := 0; i < listObj.Len(); i++ {
		v := listObj.Index(i)
		item := IgnoreDef{t: o.t}
		err := item.Unpack(v)
		if err != nil {
			return fmt.Errorf("at index %d: %v", i, err)
		}
		items = append(items, v1alpha1.IgnoreDef(item.Value))
	}

	listObj.Freeze()
	o.List = listObj
	o.Value = items

	return nil
}

// Probe type
type Probe struct {
	*starlark.Dict
	Value      v1alpha1.Probe
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) probe(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var handler starlark.Value
	var initialDelaySeconds starlark.Value
	var timeoutSeconds starlark.Value
	var periodSeconds starlark.Value
	var successThreshold starlark.Value
	var failureThreshold starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"handler?", &handler,
		"initial_delay_seconds?", &initialDelaySeconds,
		"timeout_seconds?", &timeoutSeconds,
		"period_seconds?", &periodSeconds,
		"success_threshold?", &successThreshold,
		"failure_threshold?", &failureThreshold,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(6)
	if handler != nil {
		err := dict.SetKey(starlark.String("handler"), handler)
		if err != nil {
			return nil, err
		}
	}
	if initialDelaySeconds != nil {
		err := dict.SetKey(starlark.String("initial_delay_seconds"), initialDelaySeconds)
		if err != nil {
			return nil, err
		}
	}
	if timeoutSeconds != nil {
		err := dict.SetKey(starlark.String("timeout_seconds"), timeoutSeconds)
		if err != nil {
			return nil, err
		}
	}
	if periodSeconds != nil {
		err := dict.SetKey(starlark.String("period_seconds"), periodSeconds)
		if err != nil {
			return nil, err
		}
	}
	if successThreshold != nil {
		err := dict.SetKey(starlark.String("success_threshold"), successThreshold)
		if err != nil {
			return nil, err
		}
	}
	if failureThreshold != nil {
		err := dict.SetKey(starlark.String("failure_threshold"), failureThreshold)
		if err != nil {
			return nil, err
		}
	}
	var obj *Probe = &Probe{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *Probe) Unpack(v starlark.Value) error {
	obj := v1alpha1.Probe{}

	starlarkObj, ok := v.(*Probe)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "handler" {
			v := Handler{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Handler = v1alpha1.Handler(v.Value)
			continue
		}
		if key == "initial_delay_seconds" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.InitialDelaySeconds = int32(i)
			continue
		}
		if key == "timeout_seconds" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.TimeoutSeconds = int32(i)
			continue
		}
		if key == "period_seconds" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.PeriodSeconds = int32(i)
			continue
		}
		if key == "success_threshold" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.SuccessThreshold = int32(i)
			continue
		}
		if key == "failure_threshold" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.FailureThreshold = int32(i)
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// RestartOnSpec type
type RestartOnSpec struct {
	*starlark.Dict
	Value      v1alpha1.RestartOnSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) restartOnSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var fileWatches starlark.Value
	var uiButtons starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"file_watches?", &fileWatches,
		"ui_buttons?", &uiButtons,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if fileWatches != nil {
		err := dict.SetKey(starlark.String("file_watches"), fileWatches)
		if err != nil {
			return nil, err
		}
	}
	if uiButtons != nil {
		err := dict.SetKey(starlark.String("ui_buttons"), uiButtons)
		if err != nil {
			return nil, err
		}
	}
	var obj *RestartOnSpec = &RestartOnSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *RestartOnSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.RestartOnSpec{}

	starlarkObj, ok := v.(*RestartOnSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "file_watches" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.FileWatches = v
			continue
		}
		if key == "ui_buttons" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.UIButtons = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// StartOnSpec type
type StartOnSpec struct {
	*starlark.Dict
	Value      v1alpha1.StartOnSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) startOnSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var uiButtons starlark.Value
	var startAfter starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"ui_buttons?", &uiButtons,
		"start_after?", &startAfter,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if uiButtons != nil {
		err := dict.SetKey(starlark.String("ui_buttons"), uiButtons)
		if err != nil {
			return nil, err
		}
	}
	if startAfter != nil {
		err := dict.SetKey(starlark.String("start_after"), startAfter)
		if err != nil {
			return nil, err
		}
	}
	var obj *StartOnSpec = &StartOnSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *StartOnSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.StartOnSpec{}

	starlarkObj, ok := v.(*StartOnSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "ui_buttons" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.UIButtons = v
			continue
		}
		if key == "start_after" {
			var dur time.Duration
			switch x := val.(type) {
			case starlark.Float:
				dur = time.Duration(float64(x) * float64(time.Second))
			case starlark.Int:
				i, ok := x.Int64()
				if !ok {
					return fmt.Errorf("unpacking %s: expected int64, actual: %v", key, x)
				}
				dur = time.Duration(i) * time.Second
			default:
				return fmt.Errorf("unpacking %s: expected number, actual: %v", key, val.Type())
			}
			obj.StartAfter = metav1.NewTime(time.Now().Add(dur))
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// TCPSocketAction type
type TCPSocketAction struct {
	*starlark.Dict
	Value      v1alpha1.TCPSocketAction
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) tCPSocketAction(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var port starlark.Value
	var host starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"port?", &port,
		"host?", &host,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if port != nil {
		err := dict.SetKey(starlark.String("port"), port)
		if err != nil {
			return nil, err
		}
	}
	if host != nil {
		err := dict.SetKey(starlark.String("host"), host)
		if err != nil {
			return nil, err
		}
	}
	var obj *TCPSocketAction = &TCPSocketAction{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *TCPSocketAction) Unpack(v starlark.Value) error {
	obj := v1alpha1.TCPSocketAction{}

	starlarkObj, ok := v.(*TCPSocketAction)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "port" {
			v, ok := val.(starlark.Int)
			if !ok {
				return fmt.Errorf("unpacking %s: expected int, actual: %v", key, val.Type())
			}
			i, ok := v.Int64()
			if !ok {
				return fmt.Errorf("unpacking %s: expected int32, actual: %v", key, v)
			}
			obj.Port = int32(i)
			continue
		}
		if key == "host" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Host = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// UIBoolInputSpec type
type UIBoolInputSpec struct {
	*starlark.Dict
	Value      v1alpha1.UIBoolInputSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uIBoolInputSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var defaultVal starlark.Value
	var trueString starlark.Value
	var falseString starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"default_val?", &defaultVal,
		"true_string?", &trueString,
		"false_string?", &falseString,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(3)
	if defaultVal != nil {
		err := dict.SetKey(starlark.String("default_val"), defaultVal)
		if err != nil {
			return nil, err
		}
	}
	if trueString != nil {
		err := dict.SetKey(starlark.String("true_string"), trueString)
		if err != nil {
			return nil, err
		}
	}
	if falseString != nil {
		err := dict.SetKey(starlark.String("false_string"), falseString)
		if err != nil {
			return nil, err
		}
	}
	var obj *UIBoolInputSpec = &UIBoolInputSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UIBoolInputSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.UIBoolInputSpec{}

	starlarkObj, ok := v.(*UIBoolInputSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "default_val" {
			v, ok := val.(starlark.Bool)
			if !ok {
				return fmt.Errorf("unpacking %s: expected bool, actual: %v", key, val.Type())
			}
			obj.DefaultValue = bool(v)
			continue
		}
		if key == "true_string" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.TrueString = &v
			continue
		}
		if key == "false_string" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.FalseString = &v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// UIChoiceInputSpec type
type UIChoiceInputSpec struct {
	*starlark.Dict
	Value      v1alpha1.UIChoiceInputSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uIChoiceInputSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var choices starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"choices?", &choices,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(1)
	if choices != nil {
		err := dict.SetKey(starlark.String("choices"), choices)
		if err != nil {
			return nil, err
		}
	}
	var obj *UIChoiceInputSpec = &UIChoiceInputSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UIChoiceInputSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.UIChoiceInputSpec{}

	starlarkObj, ok := v.(*UIChoiceInputSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "choices" {
			var v value.StringList
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Choices = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// UIComponentLocation type
type UIComponentLocation struct {
	*starlark.Dict
	Value      v1alpha1.UIComponentLocation
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uIComponentLocation(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var componentID starlark.Value
	var componentType starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"component_id?", &componentID,
		"component_type?", &componentType,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if componentID != nil {
		err := dict.SetKey(starlark.String("component_id"), componentID)
		if err != nil {
			return nil, err
		}
	}
	if componentType != nil {
		err := dict.SetKey(starlark.String("component_type"), componentType)
		if err != nil {
			return nil, err
		}
	}
	var obj *UIComponentLocation = &UIComponentLocation{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UIComponentLocation) Unpack(v starlark.Value) error {
	obj := v1alpha1.UIComponentLocation{}

	starlarkObj, ok := v.(*UIComponentLocation)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "component_id" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.ComponentID = v
			continue
		}
		if key == "component_type" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.ComponentType = v1alpha1.ComponentType(v)
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// UIHiddenInputSpec type
type UIHiddenInputSpec struct {
	*starlark.Dict
	Value      v1alpha1.UIHiddenInputSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uIHiddenInputSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var value starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"value?", &value,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(1)
	if value != nil {
		err := dict.SetKey(starlark.String("value"), value)
		if err != nil {
			return nil, err
		}
	}
	var obj *UIHiddenInputSpec = &UIHiddenInputSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UIHiddenInputSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.UIHiddenInputSpec{}

	starlarkObj, ok := v.(*UIHiddenInputSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "value" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Value = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

// UIInputSpec type
type UIInputSpec struct {
	*starlark.Dict
	Value      v1alpha1.UIInputSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uIInputSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var name starlark.Value
	var label starlark.Value
	var text starlark.Value
	var boolean starlark.Value
	var hidden starlark.Value
	var choice starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"name?", &name,
		"label?", &label,
		"text?", &text,
		"bool?", &boolean,
		"hidden?", &hidden,
		"choice?", &choice,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(6)
	if name != nil {
		err := dict.SetKey(starlark.String("name"), name)
		if err != nil {
			return nil, err
		}
	}
	if label != nil {
		err := dict.SetKey(starlark.String("label"), label)
		if err != nil {
			return nil, err
		}
	}
	if text != nil {
		err := dict.SetKey(starlark.String("text"), text)
		if err != nil {
			return nil, err
		}
	}
	if boolean != nil {
		err := dict.SetKey(starlark.String("bool"), boolean)
		if err != nil {
			return nil, err
		}
	}
	if hidden != nil {
		err := dict.SetKey(starlark.String("hidden"), hidden)
		if err != nil {
			return nil, err
		}
	}
	if choice != nil {
		err := dict.SetKey(starlark.String("choice"), choice)
		if err != nil {
			return nil, err
		}
	}
	var obj *UIInputSpec = &UIInputSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UIInputSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.UIInputSpec{}

	starlarkObj, ok := v.(*UIInputSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "name" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Name = v
			continue
		}
		if key == "label" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Label = v
			continue
		}
		if key == "text" {
			v := UITextInputSpec{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Text = (*v1alpha1.UITextInputSpec)(&v.Value)
			continue
		}
		if key == "bool" {
			v := UIBoolInputSpec{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Bool = (*v1alpha1.UIBoolInputSpec)(&v.Value)
			continue
		}
		if key == "hidden" {
			v := UIHiddenInputSpec{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Hidden = (*v1alpha1.UIHiddenInputSpec)(&v.Value)
			continue
		}
		if key == "choice" {
			v := UIChoiceInputSpec{t: o.t}
			err := v.Unpack(val)
			if err != nil {
				return fmt.Errorf("unpacking %s: %v", key, err)
			}
			obj.Choice = (*v1alpha1.UIChoiceInputSpec)(&v.Value)
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}

type UIInputSpecList struct {
	*starlark.List
	Value []v1alpha1.UIInputSpec
	t     *starlark.Thread
}

func (o *UIInputSpecList) Unpack(v starlark.Value) error {
	items := []v1alpha1.UIInputSpec{}

	listObj, ok := v.(*starlark.List)
	if !ok {
		return fmt.Errorf("expected list, actual: %v", v.Type())
	}

	for i := 0; i < listObj.Len(); i++ {
		v := listObj.Index(i)
		item := UIInputSpec{t: o.t}
		err := item.Unpack(v)
		if err != nil {
			return fmt.Errorf("at index %d: %v", i, err)
		}
		items = append(items, v1alpha1.UIInputSpec(item.Value))
	}

	listObj.Freeze()
	o.List = listObj
	o.Value = items

	return nil
}

// UITextInputSpec type
type UITextInputSpec struct {
	*starlark.Dict
	Value      v1alpha1.UITextInputSpec
	isUnpacked bool
	t          *starlark.Thread
}

func (p Plugin) uITextInputSpec(t *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var defaultVal starlark.Value
	var placeholder starlark.Value
	err := starkit.UnpackArgs(t, fn.Name(), args, kwargs,
		"default_val?", &defaultVal,
		"placeholder?", &placeholder,
	)
	if err != nil {
		return nil, err
	}

	dict := starlark.NewDict(2)
	if defaultVal != nil {
		err := dict.SetKey(starlark.String("default_val"), defaultVal)
		if err != nil {
			return nil, err
		}
	}
	if placeholder != nil {
		err := dict.SetKey(starlark.String("placeholder"), placeholder)
		if err != nil {
			return nil, err
		}
	}
	var obj *UITextInputSpec = &UITextInputSpec{t: t}
	err = obj.Unpack(dict)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func (o *UITextInputSpec) Unpack(v starlark.Value) error {
	obj := v1alpha1.UITextInputSpec{}

	starlarkObj, ok := v.(*UITextInputSpec)
	if ok {
		*o = *starlarkObj
		return nil
	}

	mapObj, ok := v.(*starlark.Dict)
	if !ok {
		return fmt.Errorf("expected dict, actual: %v", v.Type())
	}

	for _, item := range mapObj.Items() {
		keyV, val := item[0], item[1]
		key, ok := starlark.AsString(keyV)
		if !ok {
			return fmt.Errorf("key must be string. Got: %s", keyV.Type())
		}

		if key == "default_val" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.DefaultValue = v
			continue
		}
		if key == "placeholder" {
			v, ok := starlark.AsString(val)
			if !ok {
				return fmt.Errorf("unpacking %s: expected string, actual: %v", key, val.Type())
			}
			obj.Placeholder = v
			continue
		}
		return fmt.Errorf("Unexpected attribute name: %s", key)
	}

	mapObj.Freeze()
	o.Dict = mapObj
	o.Value = obj
	o.isUnpacked = true

	return nil
}
