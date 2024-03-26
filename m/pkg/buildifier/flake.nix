{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildifier"; };

    url_template = input: "https://github.com/bazelbuild/buildtools/releases/download/v${input.vendor}/buildifier-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildifier
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-7cngXaVpy5mih0ZGZKI1DoXpb9WRuG9mwVJ4cK2WwNo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-iazkNC41leT+2pwc4gVUJJKjOkgaPQh1oag0SKc8hxQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-cAKh9+nEH+0kIQq9367Q9G8avFcw+qzgPvnr3SueEl4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Hm9JWaewAk863agNkvqE4Bk6mdI0uwDLE9kA+AwIvWw="; # aarch64-darwin
      };
    };
  };
}
