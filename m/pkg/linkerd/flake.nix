{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/stable-${input.vendor}/linkerd2-cli-stable-${input.vendor}-${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/linkerd
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "-amd64";
        sha256 = "sha256-P1IClQIOFH5DiBkNwqhaVQ4BLaD2iQWUW1fjBMOUD/o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-FxmEBACl8yYHBhavqtoAeeQDo5M+R+k8FogDjib08Ac="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-fbsqeyTUdt0DcqoTOY1Dqcqm0NUT6+wH+S98gaAf1CI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-WOdbfw4Rm/iyd2q9jHX6yF6thibbYFBLAnmw1VUaIDQ="; # aarch64-darwin
      };
    };
  };
}
