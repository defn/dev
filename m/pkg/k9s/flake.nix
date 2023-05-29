{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-5QeDHr1fm4wDgPISZp81LG40y3YMkWtJi6uui+g8Q5I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-BfewVLL0GmnxOJPsgZqKykNmKkutYZUemIem+S7L8tg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-eo0NpOL/9v9mHfblHQvUo6dX4SCWAoVy6D5IVyS+DBU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-zuUw2ufdaYe3uv6hzi+neLMtZU+FU9sQCzShCwZfaIk="; # aarch64-darwin
      };
    };
  };
}
