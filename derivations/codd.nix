{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream,
  gettext,
  cargo,
  rustc,
  rustPlatform,
  gtk4,
  libadwaita,
  gtksourceview5,
  openssl,
  glib,
  gsettings-desktop-schemas,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codd";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "anil-e";
    repo = "codd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NV9Hu7sPSX0in8MqrJRjdSFy5nxM662Zzd26JUAY0UA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream
    gettext
    libxml2
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    gtksourceview5
    openssl
    glib
    gsettings-desktop-schemas
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight native PostgreSQL client for GNOME, built with Rust and GTK4";
    homepage = "https://github.com/anil-e/codd";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "codd";
  };
})
