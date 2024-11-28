{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:
buildNpmPackage rec {
  pname = "chatbox";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "Bin-Huang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n3+qfIJyRv3OWSOQvmJRThjivpoa8OLEnxs8TYLi4Ng=";
  };

  npmDepsHash = "sha256-1o0LqUS2k+nNmAEnL7wrqEFjJ+GxKfczpeamVEejm4U=";

  nativeBuildInputs = [ electron ];

  dontNpmBuild = true;
  makeCacheWritable = true;

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/lib/node_modules/${pname}/main.js
  '';
}
