{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  makeDesktopItem,
}:

let
  pname = "edex-ui";
  version = "2.2.8";

  src = fetchurl {
    url = "https://github.com/GitSquared/edex-ui/releases/download/v${version}/eDEX-UI-Linux-x86_64.AppImage";
    hash = "sha256-yPKM1yHKAyygwZYLdWyj5k3EQaZDwy6vu3nGc7QC1oE=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libxshmfence
    ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = "edex-ui";
      comment = "eDEX-UI sci-fi interface";
      categories = [ "System" ];
      terminal = false;
      type = "Application";
      startupWMClass = "eDEX-UI";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "edex-ui";
    description = "eDEX-UI sci-fi interface";
    homepage = "https://github.com/GitSquared/edex-ui";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    changelog = "https://github.com/GitSquared/edex-ui/releases/tag/v${version}";
  };
}
