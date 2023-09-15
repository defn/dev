{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/alexellis/k3sup/releases/download/${input.vendor}/k3sup${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3sup
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "";
        arch = "";
        sha256 = "sha256-J6cp1t4GWWJMBmphDZaHRUkI5DnAWOwiKxb4/1YNoco="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-nf29dZjX+VIM/RkMZ3l0MRYbJwKapYEZ4atfFQd1AL0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-5ikh/zfwiPmLMDdWJLDqXHp1oaGV1wvNXCYeneXra2c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-H8Uw8n89K5MRLiloW0V12ISWOza9nNekZMvxcF1f5lE="; # aarch64-darwin
      };
    };
  };
}
