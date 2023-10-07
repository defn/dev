{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/buildkite/agent/releases/download/v${input.vendor}/buildkite-agent-${input.os}-${input.arch}-${input.vendor}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buildkite-agent $out/bin/buildkite-agent
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Ule9TbO/JsAGEGzL80qpLIUlNdpav9ACjxt9dz+pC3k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-h9FlaCvuq6RRT8OdQ1JySf6rXRFVqO41egO/wwT6kDg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-43OrFwROAz+gKNIjZlStDc4AlGxrlTAx0zNxZPqDQmI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-43OrFwROAz+gKNIjZlStDc4AlGxrlTAx0zNxZPqDQmI="; # aarch64-darwin
      };
    };
  };
}
