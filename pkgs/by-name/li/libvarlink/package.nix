{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvarlink";
  version = "24";

  src = fetchFromGitHub {
    owner = "varlink";
    repo = "libvarlink";
    tag = finalAttrs.version;
    sha256 = "sha256-/BWbbDFLxa1da5ewrt3DG/+096dZ+s6p8VdcRGDiEiU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];

  postPatch = ''
    # test-object: ../lib/test-object.c:129: main: Assertion `setlocale(LC_NUMERIC, "de_DE.UTF-8") != 0' failed.
    # PR that added it https://github.com/varlink/libvarlink/pull/27
    substituteInPlace lib/test-object.c \
      --replace 'assert(setlocale(LC_NUMERIC, "de_DE.UTF-8") != 0);' ""

    patchShebangs lib/test-symbols.sh varlink-wrapper.py
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "varlink --version";
      };
    };
  };

  meta = with lib; {
    description = "C implementation of the Varlink protocol and command line tool";
    mainProgram = "varlink";
    homepage = "https://github.com/varlink/libvarlink";
    license = licenses.asl20;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
})
