{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/int128/kubelogin/releases/download/v${input.vendor}/kubelogin_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 kubelogin $out/bin/kubectl-oidc_login
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
        sha256 = "sha256-rqwnULnV8YDS+UPYyjrCwGskORyNTFeuQXLNsRIBBu0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-yU1zG1JGWmigMkWsY16JMguiVSpXl3HET4Mou4Ma9fU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-6ARShaB6IPTH4oCI9o1vA8NOZFsxSRS/QMhQYoHkchk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-biOINgbLXHlNypfgEILng4FynuDEy34GkAN7cNTyyhQ="; # aarch64-darwin
      };
    };
  };
}
