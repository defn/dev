{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/boundary/${input.vendor}/boundary_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 boundary $out/bin/boundary
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-flSZIsDLMeRvu7tS6qbPzL9ABGuKUIRK32RMnvM1y5c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-XXy3BB7G1WGyVslDnoPFc9p6X4pRRvpmHHendFc4bHw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-XqdNv86NxRtxiWFIa7Kgpd3LfSqIkHvs/SQEzWW9t14="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-oUi0AWSz/3UI+um8jCvTQ330zWxb6agZMSvoke6aerc="; # aarch64-darwin
      };
    };
  };
}
