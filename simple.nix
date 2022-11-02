with (import <nixpkgs> {});
derivation {
  inherit coreutils findutils gnutar gzip;
  name = "simple";
  builder = "${bash}/bin/bash";
  args = [ ./simple.sh ];
  download = /nix/store/5qx34wwpqakxadshwavhbsrv39syayxs-tilt.0.30.10.linux.x86_64.tar.gz;
  system = builtins.currentSystem;
}