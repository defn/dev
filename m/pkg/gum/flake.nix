{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 gum $out/bin/gum
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-8xxB0g4BfRFedlBxmlPnoqwPCsFNs7Jxlmq94eQ2EC4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-+AsOoQO7zY3SBWsWOwUBXfD7kUTyOGlPZQUFJCSEoCk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-35qtsvLTgrRNZEEXg/7nE/ivobPnRFju0PUIjviMS+Q="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-42a6lIkmhx7dQyea37+o8Z8LfC9hmeFAjnmIuMpXNiI="; # aarch64-darwin
      };
    };
  };
}
