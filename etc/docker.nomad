job "docker" {
  datacenters = ["dc1"]

  group "shell" {
    task "server" {
      driver = "docker"

      resources {
        memory = 100
      }

      config {
        image = "ubuntu"

        args = [
          "sleep",
          "86401"
        ]
      }

      template {
        data = <<EOF
feh
EOF
        destination = "secrets/secrets.txt"
      }
    }
  }
}
