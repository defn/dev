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
        sha256 = "sha256-0UAhg15o5IJNxCC07OtFhlyfhUkfQ7Xezsbxesw5neM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-C5x+w0Cl17u20w7RosS8Gn7SFtgbnvJURzG+/5p6yDo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-5jf9JiMtu4koFtZNaOEaLT9DHcn9OG1cJDriyHvMaBE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-KPphLZF0BfOxu2D0x0tsIkhx3p33qhxSJRILAx0b6X4="; # aarch64-darwin
      };
    };
  };
}
