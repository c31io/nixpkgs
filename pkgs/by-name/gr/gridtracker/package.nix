{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  nwjs,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gridtracker";
  version = "1.24.0922";

  src = fetchFromGitLab {
    owner = "gridtracker.org";
    repo = "gridtracker";
    tag = "v${version}";
    hash = "sha256-6WgP13JVOzYnYtCDH3qCQXT70X9j4yqlUb18FFf1aSY=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '$(DESTDIR)/usr' '$(DESTDIR)/'
    substituteInPlace gridtracker.sh \
      --replace "exec nw" "exec ${nwjs}/bin/nw" \
      --replace "/usr/share/gridtracker" "$out/share/gridtracker"
    substituteInPlace gridtracker.desktop \
      --replace "/usr/share/gridtracker/gridview.png" "$out/share/gridtracker/gridview.png"
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "NO_DIST_INSTALL=1"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Amateur radio companion to WSJT-X or JTDX";
    mainProgram = "gridtracker";
    longDescription = ''
      GridTracker listens to traffic from WSJT-X/JTDX, displays it on a map,
      and has a sophisticated alerting and filtering system for finding and
      working interesting stations. It also will upload QSO records to multiple
      logging frameworks including Logbook of the World.
    '';
    homepage = "https://gridtracker.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
