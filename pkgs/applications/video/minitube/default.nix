{
  mkDerivation,
  lib,
  fetchFromGitHub,
  phonon,
  phonon-backend-vlc,
  qtbase,
  qmake,
  qtdeclarative,
  qttools,
  qtx11extras,
  mpv,

  # "Free" key generated by pasqui23
  withAPIKey ? "AIzaSyBQvZXseEVvgu5Ega_DI-AIJ55v0OsHmVY",
}:

mkDerivation rec {
  pname = "minitube";
  version = "3.9.3";

  src = fetchFromGitHub {
    hash = "sha256-ROqROQsV8ddrxYT5mMdkf6rCgCoGr1jpxQ1ohcoEaQs=";
    tag = version;
    repo = "minitube";
    owner = "flaviotordini";
    fetchSubmodules = true;
  };

  patches = [
    # Taken from FreeBSD; already merged upstream in the media submodule
    # (https://github.com/flaviotordini/media/commit/f6b7020f273e1fc06e6e204fab37a7c8edaa857a)
    ./lib_media_src_mpv_mpvwidget.patch
  ];

  nativeBuildInputs = [
    qmake
    qttools
  ];

  buildInputs = [
    phonon
    phonon-backend-vlc
    qtbase
    qtdeclarative
    qtx11extras
    mpv
  ];

  qmakeFlags = [ "DEFINES+=APP_GOOGLE_API_KEY=${withAPIKey}" ];

  meta = with lib; {
    description = "Stand-alone YouTube video player";
    longDescription = ''
      Watch YouTube videos in a new way: you type a keyword, Minitube gives
      you an endless video stream. Minitube is not about cloning the YouTube
      website, it aims to create a new TV-like experience.
    '';
    homepage = "https://flavio.tordini.org/minitube";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "minitube";
  };
}
