{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  sqlite,
  libosmoabis,
  libosmo-netif,
  libosmo-sigtran,
  osmo-mgw,
  osmo-hlr,
  lksctp-tools,
}:

stdenv.mkDerivation rec {
  pname = "osmo-msc";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-msc";
    tag = version;
    hash = "sha256-iS/N0+KhgMUFoJus/R/iFOLuvqCiceNtcuq3nbOvBts=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    sqlite
    libosmoabis
    libosmo-netif
    libosmo-sigtran
    osmo-mgw
    osmo-hlr
    lksctp-tools
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Mobile Swtiching Centre (MSC)";
    mainProgram = "osmo-msc";
    homepage = "https://osmocom.org/projects/osmomsc/wiki";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
}
