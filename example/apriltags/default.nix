{ stdenv, fetchFromGitHub, cmake, pkg-config, opencv4, eigen }:
stdenv.mkDerivation {
  name = "apriltags";

  src = fetchFromGitHub {
    owner = "AprilRobotics";
    repo = "apriltags";
    rev = "v3.2.0";
    sha256 = "sha256-pJFTzWX8zLzcDfPCg8v44fwlxEMVeRylcggFk7B5m7g=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ opencv4 eigen ];

  enableParallelBuilding = true;
}
