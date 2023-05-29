{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/operator-framework/operator-sdk/releases/download/v${input.vendor}/operator-sdk_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/operator-sdk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Z7aTUshVtytN7uYwl3k41ZD6BY6kyPGin9vFejMf45U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HMhQSnrxlBqq3qpL47BvUU8PibWNDYbLX08QbFZDmB8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-O3yRWxYwWKs8DI+n31XnrIsOGTFEU0kDM10fN5o6T/s="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-G8PSB7Ufq9AATj1zT01Y5+WB+qI5J2MIqB/CjWsW+tw="; # aarch64-darwin
      };
    };
  };
}
