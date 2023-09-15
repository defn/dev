{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input:
      if input.os == "darwin" then
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-apple-${input.os}.tar.gz"
      else
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-unknown-${input.os}-musl.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 zellij $out/bin/zellij
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-dc8X16d6InXSinJYH8u2AXol8GspyKobH/D1pnafzxY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-UDU8WeDru8on3WsN8lLmecMyJKEI2WZuur2t784dFMo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-8SWQNweRmlELXHNzMDlQIqUVk07X+Zu/De9QSgwkiQI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "aarch64";
        sha256 = "sha256-JFxxnNIEbF1vKglayTnToZc+3Lk+ATm+7FdmSanwbTk="; # aarch64-darwin
      };
    };
  };
}
