# nomad job run etc/hello.nomad 
# cue export --out json -e jobs.hello etc/hello.cue > etc/hello.json
# nomad job run -json etc/hello.json
job "hello" {
  datacenters = ["dc1"]

  group "hello" {
    task "hello" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = ["-c", "uname -a; exec sleep infinity"]
      }

      resources {
        cpu    = 100 # CPU in MHz
        memory = 128 # Memory in MB
      }
    }
  }
}
