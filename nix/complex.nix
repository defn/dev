with import <nixpkgs> {};
stdenv.mkDerivation rec {
  pname = "complex";
  version = "0.0.1";
  buildInputs = [];
  builder = ./complex.sh;
  setSourceRoot = "sourceRoot=`pwd`";
  src = fetchurl {
    url = "https://github.com/tilt-dev/tilt/releases/download/v0.30.10/tilt.0.30.10.linux.x86_64.tar.gz";
    sha256 = "67133d806f900eef0a36665b39b8c9ef7d70eacb0f4876ede3ce627049aaa6cf";
  };
}