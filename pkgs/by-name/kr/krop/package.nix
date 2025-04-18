{
  lib,
  fetchFromGitHub,
  python3,
  libsForQt5,
  ghostscript,
  qt5,
  fetchPypi,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      # Can be removed once this is merged
      # https://github.com/arminstraub/krop/pull/40
      pypdf2 = super.pypdf2.overridePythonAttrs (oldAttrs: rec {
        version = "2.12.1";
        src = fetchPypi {
          pname = "PyPDF2";
          inherit version;
          hash = "sha256-4D7xirzHXadBoKzBp3SSU0loh744zZiHvM4c7jk9pF4=";
        };
      });
    };
  };
in

py.pkgs.buildPythonApplication rec {
  pname = "krop";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "arminstraub";
    repo = pname;
    tag = "v${version}";
    sha256 = "1ygzc7vlwszqmsd3v1dsqp1dpsn6inx7g8gck63alvf88dbn8m3s";
  };

  propagatedBuildInputs = with py.pkgs; [
    pyqt5
    pypdf2
    poppler-qt5
    ghostscript
  ];

  buildInputs = [
    libsForQt5.poppler
    libsForQt5.qtwayland
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  postInstall = ''
    install -m666 -Dt $out/share/applications krop.desktop
  '';

  # Disable checks because of interference with older Qt versions // xcb
  doCheck = false;

  meta = {
    homepage = "http://arminstraub.com/software/krop";
    description = "Graphical tool to crop the pages of PDF files";
    longDescription = ''
      Krop is a tool that allows you to optimise your PDF files, and remove
      sections of the page you do not want.  A unique feature of krop, at least to my
      knowledge, is its ability to automatically split pages into subpages to fit the
      limited screensize of devices such as eReaders. This is particularly useful, if
      your eReader does not support convenient scrolling. Krop also has a command line
      interface.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leenaars ];
    platforms = lib.platforms.linux;
    mainProgram = "krop";
  };
}
