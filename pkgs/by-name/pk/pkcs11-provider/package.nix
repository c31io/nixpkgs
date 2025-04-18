{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  p11-kit,
  opensc,
  gnutls,
  expect,
  which,
  meson,
  ninja,
  pkg-config,
  valgrind,
  python3,
  nix-update-script,
}:

let
  pkcs11ProviderPython3 = python3.withPackages (pythonPkgs: with pythonPkgs; [ six ]);
in
stdenv.mkDerivation rec {
  pname = "pkcs11-provider";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "pkcs11-provider";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Q9dmzYDBco+LLVWdORFTjRyk0RX8qhmZ1m+Kgfeyr04=";
  };

  buildInputs = [
    openssl
    nss
    p11-kit
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which
  ];

  # don't add SoftHSM to here: https://github.com/openssl/openssl/issues/22508
  nativeCheckInputs = [
    p11-kit.bin
    opensc
    nss.tools
    gnutls
    openssl.bin
    expect
    valgrind
    pkcs11ProviderPython3
  ];

  postPatch = ''
    patchShebangs --build .
  '';

  preInstall = ''
    # Meson tries to install to `$out/$out` and `$out/''${openssl.out}`; so join them.
    mkdir -p "$out"
    for dir in "$out" "${openssl.out}"; do
      mkdir -p .install/"$(dirname -- "$dir")"
      ln -s "$out" ".install/$dir"
    done
    export DESTDIR="$(realpath .install)"
  '';

  enableParallelBuilding = true;

  # Frequently fails due to a race condition.
  enableParallelInstalling = false;

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(\\d\\.\\d)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    maintainers = with maintainers; [ numinit ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
