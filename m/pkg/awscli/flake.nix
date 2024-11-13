{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain
    rec {
      src = builtins.path { path = ./.; name = "pkg-awscli"; };

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
        ln -nfs aws $out/bin/pkg-awscli
        ln -nfs aws $out/bin/awscli
        chmod -R g-s $out/.
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
          sha256 = "sha256-yicvyOMbTQplJXC7ekQDmaVZslNkiBt0KQhc+ArM14U="; # x86_64-linux
        };
        "aarch64-linux" = rec {
          os = "linux";
          arch = "aarch64";
          sha256 = "sha256-6Fh292e2wj4DcqWE91YR8TR1mQcboe7u3IzINuQUTO8="; # aarch64-linux
        };
        "x86_64-darwin" = rec {
          os = "darwin";
          sha256 = "sha256-NNBCranyJnlI/BULvn/oSgP+H1HJvm8ew842U0UE52M="; # x86_64-darwin
        };
        "aarch64-darwin" = rec {
          os = "darwin";
          sha256 = "sha256-NNBCranyJnlI/BULvn/oSgP+H1HJvm8ew842U0UE52M="; # aarch64-darwin
        };
      };
    };
}
