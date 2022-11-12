rec {
  slug = "defn-dev-min";
  version = "0.0.1";
  homepage = "https://defn.sh/${slug}";
  description = "minimal flake config";
  downloads = {
    "x86_64-linux" = rec {
      os = "linux";
      arch = "x86_64";
      url = "";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "aarch64-linux" = rec {
      os = "linux";
      arch = "arm64";
      url = "";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "x86_64-darwin" = rec {
      os = "darwin";
      arch = "x86_64";
      url = "";
      sha256 = "sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
    "aarch64-darwin" = rec {
      os = "darwin";
      arch = "x86_64";
      url = "";
      sha256 = " sha256-K1LJVGyxXb9gzJTVobSuyoMNIR+uRVLiWg/oiMkU9qc=";
    };
  };
}

