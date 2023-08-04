# nomad job run etc/hello.nomad 
# cue export --out json -e jobs.hello etc/hello.cue  | nomad job run -json -
job "demo3" {
  datacenters = ["dc1"]

  group "demo3" {
    restart {
      attempts = 100
      delay = "10s"
    }
    task "demo3" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = ["-c", "ls /. hamburger 2> /dev/null; uname -a; exec sleep infinity"]
      }

      resources {
        cpu    = 100 # CPU in MHz
        memory = 50 # Memory in MB
      }
    }
  }
}