# nomad job run etc/hello.nomad 
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
