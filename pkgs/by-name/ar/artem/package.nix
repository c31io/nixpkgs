{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = "artem";
    tag = "v${version}";
    hash = "sha256-C3Co+hXstVN/WADIpzqr7f3muAgQL0Zbnz6VI1XNo4U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OPcT2iMZPx1mXXtghznq65YQtfxsOV1etgqZMMLzkmo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # require internet access
    "--skip=arguments::input::url_input"
    "--skip=full_file_compare_url"

    # flaky
    "--skip=full_file_compare_html"
  ];

  postInstall = ''
    installManPage $releaseDir/build/artem-*/out/artem.1
    installShellCompletion $releaseDir/build/artem-*/out/artem.{bash,fish} \
      --zsh $releaseDir/build/artem-*/out/_artem
  '';

  meta = with lib; {
    description = "Small CLI program to convert images to ASCII art";
    homepage = "https://github.com/finefindus/artem";
    changelog = "https://github.com/finefindus/artem/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "artem";
  };
}
