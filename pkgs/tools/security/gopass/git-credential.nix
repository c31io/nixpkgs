{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.15.15";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    tag = "v${version}";
    hash = "sha256-xtZAT1Lb7YJ0Hy2cMT2riVbEoWtz7lusKJ9QT4ZI6Ek=";
  };

  vendorHash = "sha256-onpg0CRm5HSfMEejhn2ycnV1GuukX1SK4FZN/KjEiR4=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
    mainProgram = "git-credential-gopass";
  };
}
