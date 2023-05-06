{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain
    rec {
      src = ./.;

      # https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst
      url_template = input:
        if input.os == "linux" then
          "https://awscli.amazonaws.com/awscli-exe-${input.os}-${input.arch}-${input.vendor}.zip"
        else
          "https://awscli.amazonaws.com/AWSCLIV2-${input.vendor}.pkg";

      installPhase = pkg: ''
        case $src in
          *.zip)
            unzip $src
            mkdir -p $out/bin $out/awscli
            aws/install -i $out/awscli -b $out/bin
            ;;
          *.pkg)
              xar -xf $src
              mkdir -p $out/bin $out/awscli
              cd aws-cli.pkg
              zcat Payload | (cd $out && cpio -i && mkdir awscli/v2 && mv aws-cli awscli/v2/dist && ln -nfs ../awscli/v2/dist/aws ../awscli/v2/dist/aws_completer bin/)
            ;;
        esac
      '';

      downloads = {
        options = pkg: {
          dontUnpack = true;
          buildInputs = with pkg.ctx.pkgs; [
            unzip
            xar
            cpio
          ];
        };

        "x86_64-linux" = rec {
          os = "linux";
          arch = "x86_64";
          sha256 = "sha256-D7LuhybC/uwznHL9Nf3NyxbiI6dWOV+9Ek54TqKuDLE="; # x86_64-linux
        };
        "aarch64-linux" = rec {
          os = "linux";
          arch = "aarch64";
          sha256 = "sha256-CXC6ynKJ5gqaoSM9K/OyBpjtaFwfNqz3i/o8DB0Cs6o="; # aarch64-linux
        };
        "x86_64-darwin" = rec {
          os = "darwin";
          sha256 = "sha256-xvSr0r0RwmxcjnkkyEd7Z2AxqL8uaq4DfTmA6OPu+ng="; # x86_64-darwin
        };
        "aarch64-darwin" = rec {
          os = "darwin";
          sha256 = "sha256-xvSr0r0RwmxcjnkkyEd7Z2AxqL8uaq4DfTmA6OPu+ng="; # aarch64-darwin
        };
      };
    };
}
