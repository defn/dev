{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dyff"; };

    url_template = input: "https://github.com/homeport/dyff/releases/download/v${input.vendor}/dyff_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dyff $out/bin/dyff
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-QDpMPlbpjneDah2Sy7vJ+yyKzZOFx5MVjwZzXi2a19Y="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ghY2W3wWaEhF3otEPBUj+DB2HJNuG6K/QK54KLGPDWA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-GOMPWfnJ09xw25tvJMlvomsHrjQ+HnUOUP+3cWJiMq0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-C3AgZxT19UAhGp9EepAYQ8RVxyA9DO6cKI+EEQ55mYk="; # aarch64-darwin
      };
    };
  };
}
