job "docker" {
  datacenters = ["grove"]

  group "shell" {
    task "server" {
      driver = "docker"

      config {
        image = "ubuntu"

        args = [
          "sleep",
          "86400"
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
