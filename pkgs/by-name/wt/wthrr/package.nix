{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "wthrr";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ttytm";
    repo = "wthrr-the-weathercrab";
    tag = "v${version}";
    hash = "sha256-8o84FFdcEPRtbsxWCc97tTGGownxlhpIM71GiBRT6uM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-q2WkdSb6UKY1/Aut3W70vCQPsqhqv6DPuT40RaGZWAM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  checkFlags = [
    # requires internet access
    "--skip=modules::localization::tests::translate_string"
    "--skip=modules::location::tests::geolocation_response"
  ];

  meta = with lib; {
    description = "Weather companion for the terminal";
    homepage = "https://github.com/ttytm/wthrr-the-weathercrab";
    changelog = "https://github.com/ttytm/wthrr-the-weathercrab/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "wthrr";
  };
}
