{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-linkerd"; };

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/${input.edition}-${input.vendor}/linkerd2-cli-${input.edition}-${input.vendor}-${input.os}${input.arch}";

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
        sha256 = "sha256-v8hGlLTvP2IkvsGjYHTrkSpKvFo4LPJ9N1p7TuEfTf8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-ygeisLUmbfbl96yiLvE0DF/HOGhZszZZPBhVBcXPuzs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-0UcDBpxUGe82bkrumUjcl3rh2VjVTujsL885IvXkJag="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-492UmQptZ0ugAAdJzUSRPz3au17HixegDLmb2EAlmv8="; # aarch64-darwin
      };
    };
  };
}
