{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  firefoxPaths = [
    "lib/mozilla/native-messaging-hosts"

    # wrapFirefox only links lib/mozilla path, so this is ineffective
    # Still the above path works, despite documentation stating otherwise
    # See: https://librewolf.net/docs/faq/#how-do-i-get-native-messaging-to-work
    # "lib/librewolf/native-messaging-hosts"
  ];

  chromiumPaths = [
    "etc/chromium/native-messaging-hosts"
    "etc/opt/vivaldi/native-messaging-hosts"
    "etc/opt/chrome/native-messaging-hosts"
    "etc/opt/edge/native-messaging-hosts"
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "ff2mpv-rust";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "ryze312";
    repo = "ff2mpv-rust";
    tag = version;
    hash = "sha256-3ZKVa1pRorzTM6jCXak/aTq9iyDGT7fWLOcCotLYlkc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-80NnJNTyMY6yPjZdkSW6qulR42+dxonMx1TBkMjnhXw=";

  postInstall = ''
    $out/bin/ff2mpv-rust manifest > manifest.json
    $out/bin/ff2mpv-rust manifest_chromium > manifest_chromium.json

    for path in ${toString firefoxPaths}
    do
        mkdir -p "$out/$path"
        cp manifest.json "$out/$path/ff2mpv.json"
    done

    for path in ${toString chromiumPaths}
    do
        mkdir -p "$out/$path"
        cp manifest_chromium.json "$out/$path/ff2mpv.json"
    done
  '';

  meta = with lib; {
    description = "Native messaging host for ff2mpv written in Rust";
    homepage = "https://github.com/ryze312/ff2mpv-rust";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ryze ];
    mainProgram = "ff2mpv-rust";
  };
}
