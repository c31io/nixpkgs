{
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  pkg-config,
  gtk3,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "volumeicon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Maato";
    repo = "volumeicon";
    tag = version;
    hash = "sha256-zYKC7rOoLf08rV4B43TrGNBcXfSBFxWZCe9bQD9JzaA";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
    alsa-lib
  ];

  meta = with lib; {
    description = "Lightweight volume control that sits in your systray";
    homepage = "https://nullwise.com/pages/volumeicon/volumeicon.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
    license = licenses.gpl3;
    mainProgram = "volumeicon";
  };
}
