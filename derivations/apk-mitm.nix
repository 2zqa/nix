{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre_headless,
}:

mkYarnPackage rec {
  pname = "apk-mitm";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "shroudedcode";
    repo = "apk-mitm";
    rev = "v${version}";
    hash = "sha256-wcLShZ7O20i0hzz957dNmfjvxCn5lmWObTdTRF7p+I8=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';

  postInstall = ''
    # The mkYarnPackage creates a wrapper at $out/bin/apk-mitm
    # We need to ensure Java is available in PATH
    wrapProgram $out/bin/apk-mitm \
      --prefix PATH : ${lib.makeBinPath [ jre_headless ]}
  '';

  meta = with lib; {
    description = "A CLI application that automatically prepares Android APK files for HTTPS inspection";
    homepage = "https://github.com/shroudedcode/apk-mitm";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "apk-mitm";
    platforms = platforms.all;
  };
}
