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
  libjpeg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avvie";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Avvie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y3Tf+EC7uwgVpHltV3qa5aY/5S3ANminfX5RNpGTQGA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        pillow
        pycairo
        piexif
      ]
    ))
    libadwaita
  ];

  # Make libjpeg (which provies jpegtran) lossless JPG crop/rotation/etc available during runtime.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ libjpeg ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Crop images for avatars or wallpapers";
    homepage = "https://github.com/Taiko2k/Avvie";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    mainProgram = "avvie";
  };
})
