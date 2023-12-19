{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://dl.k8s.io/release/v${input.vendor}/bin/${input.os}/${input.arch}/kubectl";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kubectl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-2dx3QeXyecKO8y+74dqo68NmIjkcM0cO/tXrhCaVmXE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ce3ExoOKczLl+Cq7NWQs5/kFBZolhpCwpYXT7W3ihbM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-lJMm/YWDSF51ZeAVgJPWIXVssn1RigHGhPaq3mb8HEI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-0KIRdw6tN8iMCRAcL5opck3CR/2ajpuqlqgBhsAHbRo="; # aarch64-darwin
      };
    };
  };
}
