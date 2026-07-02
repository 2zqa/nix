{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  makeDesktopItem,
}:

let
  pname = "simplenote";
  version = "2.27.1";

  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${version}/Simplenote-linux-${version}-x86_64.AppImage";
    hash = "sha512-q6i9e9cnn6tYl9kWkEZLFqMWTDMIeut/36MCzgg0OnFL6GwVl84y7Cu972KQzG7mp5ghfbDKiT5cmRk4/xt3vw==";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libnotify
      libappindicator-gtk3
    ];

  desktopItems = [
    makeDesktopItem
    {
      name = pname;
      exec = pname;
      icon = "simplenote";
      genericName = "Note Taking Application";
      comment = "Simplenote for Linux";
      categories = [ "Utility" ];
      startupNotify = true;
    }
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "simplenote";
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    changelog = "https://github.com/Automattic/simplenote-electron/releases/tag/v${version}/RELEASE-NOTES.md";
  };
}
