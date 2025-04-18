{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-mqtt-forwarder";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    tag = "v${version}";
    hash = "sha256-jbu8O1Wag6KpN49VyXsYO8os95ctZjzuxKXoDMLyiKU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ks92eXKWWiEIhNhEMMN2VH970u64nBWLGObOda74c0o=";

  nativeBuildInputs = [ protobuf ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  checkFlags = [
    "--skip=end_to_end" # Depends on internet connectivity
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Forwarder which can be installed on the gateway to forward LoRa data over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-mqtt-forwarder";
  };
}
