rec {
  slug = "defn-dev-min";
  version = "0.8.0";
  homepage = "https://defn.sh/${slug}";
  description = "minimal flake config";
  url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.version}/gum_${input.version}_${input.os}_${input.arch}.tar.gz";
  downloads = {
    "x86_64-linux" = rec {
      inherit version;
      os = "linux";
      arch = "x86_64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "aarch64-linux" = rec {
      inherit version;
      os = "linux";
      arch = "arm64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "x86_64-darwin" = rec {
      inherit version;
      os = "darwin";
      arch = "x86_64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "aarch64-darwin" = rec {
      inherit version;
      os = "darwin";
      arch = "x86_64";
      sha256 = " sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
  };
}
