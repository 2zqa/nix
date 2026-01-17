{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  pkg-config,
  libadwaita,
  wrapGAppsHook4,
  ninja,
  desktop-file-utils,
  gtk4,
  nix-update-script,
  blueprint-compiler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dynamic-wallpaper";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dusansimic";
    repo = "dynamic-wallpaper";
    tag = "${finalAttrs.version}";
    hash = "sha256-DAdx34EYO8ysQzbWrAIPoghhibwFtoqCi8oyDVyO5lk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    (python3.withPackages (
      ps: with ps; [
        pygobject3
      ]
    ))
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic wallpaper creator for GNOME 42 and beyond";
    homepage = "https://github.com/dusansimic/dynamic-wallpaper";
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "me.dusansimic.DynamicWallpaper";
  };
})
