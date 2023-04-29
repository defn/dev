pid_file = "/tmp/vault-agent.pid"

vault {
  address = "http://100.107.114.21:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
  method "kubernetes" {
    mount_path = "auth/amanibhavam-global"
    config = {
      role = "hello"
    }
  }

  sink "file" {
    config = {
      path = "/tmp/vault-agent-token"
    }
  }
}

cache {
  use_auto_auth_token = true
}

listener "unix" {
  address = "/tmp/vault-agent.sock"
  tls_disable = true

  agent_api {
    enable_quit = true
  }
}
