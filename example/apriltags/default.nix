{ stdenv, cmake, pkg-config, opencv, eigen }:
stdenv.mkDerivation {
  name = "apriltags";

  src = ./.;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ opencv eigen ];

  enableParallelBuilding = true;
}
