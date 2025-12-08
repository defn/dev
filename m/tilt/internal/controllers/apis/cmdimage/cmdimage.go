package cmdimage

import (
	"fmt"

	"github.com/defn/dev/m/tilt/pkg/apis"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// Generate the name for the CmdImage API object from an ImageTarget and ManifestName.
func GetName(mn model.ManifestName, id model.TargetID) string {
	return apis.SanitizeName(fmt.Sprintf("%s:%s", mn.String(), id.Name))
}
