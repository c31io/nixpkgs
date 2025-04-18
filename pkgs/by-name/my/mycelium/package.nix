{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  openssl,
  darwin,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "mycelium";
  version = "0.5.7";

  sourceRoot = "${src.name}/myceliumd";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    tag = "v${version}";
    hash = "sha256-PbEoM+AnZTuo9xtwcDcTH9FZAzPzfBhX41+zVVTdgRo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-63AB63vmxXi6ugLCAOKI1eJcOB8XHWEiCc5yoIEqd+w=";

  nativeBuildInputs = [ versionCheckHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  doInstallCheck = true;

  env = {
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) mycelium;
    };
  };

  meta = with lib; {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      flokli
      matthewcroughan
      rvdp
    ];
    mainProgram = "mycelium";
  };
}
