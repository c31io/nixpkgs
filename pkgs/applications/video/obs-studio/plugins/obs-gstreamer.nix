{
  lib,
  stdenv,
  fetchFromGitHub,
  gst_all_1,
  pkg-config,
  meson,
  ninja,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-gstreamer";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-23LyxN1Vgol9uA7rDdfZXcmfhG4l0RfMYGbofbhObBE=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "'git', 'rev-parse', '--short', 'HEAD'" "'echo', '${version}'"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    obs-studio
  ];

  # - We need "getLib" instead of default derivation, otherwise it brings gstreamer-bin;
  # - without gst-plugins-base it won't even show proper errors in logs;
  # - Without gst-plugins-bad it won't find element "h264parse";
  # - gst-plugins-ugly adds "x264" to "Encoder type";
  # Tip: "could not link appsrc to videoconvert1" can mean a lot of things, enable GST_DEBUG=2 for help.
  passthru.obsWrapperArguments =
    let
      gstreamerHook =
        package: "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.getLib package}/lib/gstreamer-1.0";
    in
    with gst_all_1;
    builtins.map gstreamerHook [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
      gst-plugins-ugly
    ];

  # Fix output directory
  postInstall = ''
    mkdir $out/lib/obs-plugins
    mv $out/lib/obs-gstreamer.so $out/lib/obs-plugins/
  '';

  meta = with lib; {
    description = "OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio";
    homepage = "https://github.com/fzwoch/obs-gstreamer";
    maintainers = with maintainers; [
      ahuzik
      pedrohlc
    ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
