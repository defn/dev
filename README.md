# Local Coder

```bash
sudo apt update
sudo apt install -y openssh-client build-essential
sudo cp $(readlink -f /proc/1/cwd)/coder /usr/local/bin/
sudo curl -sSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-$(if test "$(uname -m)" == x86_64; then echo "amd64"; else echo "arm64"; fi)
sudo chmod 755 /usr/local/bin/bazel
```

[![Build status](https://badge.buildkite.com/879feda30e2616b22929338672877e85dfe82f60eb47df2e6a.svg)](https://buildkite.com/defn/dev)
