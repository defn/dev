package y

import (
    "list"
    "strings"
    "encoding/yaml"
)

crds_domain: {
    for name, val in res.customresourcedefinition {
        let domain = strings.Join(list.Slice(strings.Split(name, "-"), 0, 3), "-") 
        "\(domain)": "\(name)": val.cluster
    }
}

crds: {
    for domain, resources in crds_domain {
        "\(domain)": yaml.MarshalStream([
            for _, cr in resources 
            for _, custom_resource in cr {
                custom_resource
            }
        ])
    }
}