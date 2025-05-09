{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  fontforge,
}:

stdenv.mkDerivation rec {
  pname = "tlwg";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "fonts-tlwg";
    tag = "v${version}";
    sha256 = "hWiH5KJnYTdcrm+Kzn9HUQry8ry3SKzjA6/0536kCLQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [ fontforge ];

  meta = with lib; {
    description = "Collection of Thai scalable fonts available under free licenses";
    homepage = "https://linux.thai.net/projects/fonts-tlwg";
    license = with licenses; [
      gpl2
      publicDomain
      lppl13c
      free
    ];
    maintainers = [ maintainers.yrashk ];
  };
}
