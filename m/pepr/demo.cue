package api

#ScriptResource: {
    in: {
        name: string
        namespace: string
        script: string
        workdir: string
    }
    res: {
        apiVersion: "defn.dev/v1"
        kind: "Script"
        metadata: {
            name: in.name
            namespace: in.namespace
        }
        spec: #Script & {
            script: in.script
            workdir: in.workdir
        }
    }
}

ex: [string]: #ScriptResource

ex: demo: in: {
    name: "demo"
    namespace: "defn"
    script: "id -a"
    workdir: "/tmp"
}
