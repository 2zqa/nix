{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  replaceVars,
  makeDesktopItem,

  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  makeShellWrapper,
  copyDesktopItems,
  electron,

# nixosTests,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "freetube";
  version = "2.23.2";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "simplenote-electron";
    tag = "v${finalAttrs.version}";
    hash = "";
  };

  desktopItems = [
    makeDesktopItem
    {
      # name = pname;
      name = "Simplenote (Source)";
      # exec = pname;
      exec = "simplenote";
      icon = "simplenote";
      genericName = "Note Taking Application";
      comment = "Simplenote for Linux";
      categories = [ "Utility" ];
      startupNotify = true;
    }
  ];

  # passthru.tests = nixosTests.freetube;

  meta = {
    mainProgram = "simplenote";
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ josephfinlayson ];
    # changelog = "https://github.com/Automattic/simplenote-electron/releases/tag/v${version}/RELEASE-NOTES.md";
  };
})
