{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencl-headers,
}:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2024.05.08";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    tag = "v${version}";
    sha256 = "sha256-bIm4tGqwWX0IPKH3BwLgkf0T7YFrkN6vemYvdPrqUpw=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [ opencl-headers ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  meta = with lib; {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
