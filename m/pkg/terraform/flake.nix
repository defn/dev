{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/terraform/${input.vendor}/terraform_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 terraform $out/bin/terraform
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
        sha256 = "sha256-MXVDYamxZWRFQQS/ro3UD8awx1RAHFHFihAjteGTqik="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-d5n8jxZ/pAcQJLEcsvwYb9qxjZvt52HT8c3/rXqxnfA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-T59Ri0A5mpJx3Y5EmmM17JSk3mD8h4lxHt56S55jCkc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9pG3kxm9gtqsLYtsu1ldPoUjKWxM0gv32g0S/p7v36c="; # aarch64-darwin
      };
    };
  };
}
