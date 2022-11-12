rec {
  slug = "defn-dev-min";
  version = "0.8.0";
  homepage = "https://defn.sh/${slug}";
  description = "minimal flake config";
  downloads = {
    "x86_64-linux" = rec {
      os = "linux";
      arch = "x86_64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
      url = "https://github.com/charmbracelet/gum/releases/download/v${version}/gum_${version}_${os}_${arch}.tar.gz";
    };
    "aarch64-linux" = rec {
      os = "linux";
      arch = "arm64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
      url = "";
    };
    "x86_64-darwin" = rec {
      os = "darwin";
      arch = "x86_64";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
      url = "";
    };
    "aarch64-darwin" = rec {
      os = "darwin";
      arch = "x86_64";
      sha256 = " sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
      url = "";
    };
  };
}
