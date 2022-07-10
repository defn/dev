pid_file = "/tmp/pidfile"

vault {
  address = "http://vault.vault.svc:8200"
  tls_skip_verify = true
  retry {
    num_retries = 5
  }
}

auto_auth {
  method {
    type = "kubernetes"

    config {
        role = "demo"
    }
  }

  sink {
    type = "file"

    config = {
      path = "/tmp/file-foo"
    }
  }
}

# vault auth enable kubernetes
# vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc.cluster.local
# vault write auth/kubernetes/role/demo bound_service_account_names=default bound_service_account_namespaces=default policies=default ttl=1h
# vault agent -config agent.hcl
