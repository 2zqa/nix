{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  blueprint-compiler,
  gtk4,
  libadwaita,
  glib,
  json-glib,
  libgee,
  gtksourceview5,
  postgresql,
  sqlite,
}:

let
  libpg_query = stdenv.mkDerivation rec {
    pname = "libpg_query";
    version = "17-6.0.0";

    src = fetchFromGitHub {
      owner = "pganalyze";
      repo = "libpg_query";
      rev = "${version}";
      hash = "sha256-hwF3kowuMmc1eXMdvhoCpBxT6++wp29MRYhy4S5Jhfg=";
    };

    nativeBuildInputs = [ pkg-config ];

    enableParallelBuilding = true;

    installFlags = [ "prefix=$(out)" ];

    postInstall = ''
            mkdir -p $out/lib/pkgconfig
            cat > $out/lib/pkgconfig/pg_query.pc << EOF
      prefix=$out
      exec_prefix=\''${prefix}
      libdir=\''${exec_prefix}/lib
      includedir=\''${prefix}/include

      Name: libpg_query
      Description: C library for accessing the PostgreSQL parser outside of the server
      Version: ${version}
      Libs: -L\''${libdir} -lpg_query
      Cflags: -I\''${includedir}
      EOF
    '';

    meta = {
      description = "C library for accessing the PostgreSQL parser outside of the server";
      homepage = "https://github.com/pganalyze/libpg_query";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
    };
  };

  libcsv = stdenv.mkDerivation rec {
    pname = "libcsv";
    version = "3.0.3";

    src = fetchurl {
      url = "http://deb.debian.org/debian/pool/main/libc/libcsv/libcsv_${version}+dfsg.orig.tar.gz";
      hash = "sha256-Bv3frKcgpL52A7rWPrGDO8pbbFpptCscUYoCzaKnOu8=";
    };

    nativeBuildInputs = [ pkg-config ];

    postInstall = ''
            mkdir -p $out/lib/pkgconfig
            cat > $out/lib/pkgconfig/csv.pc << EOF
      prefix=$out
      exec_prefix=\''${prefix}
      libdir=\''${exec_prefix}/lib
      includedir=\''${prefix}/include

      Name: libcsv
      Description: Small, simple and fast CSV library written in pure ANSI C
      Version: ${version}
      Libs: -L\''${libdir} -lcsv
      Cflags: -I\''${includedir}
      EOF
    '';

    meta = {
      description = "Small, simple and fast CSV library written in pure ANSI C";
      homepage = "https://sourceforge.net/projects/libcsv/";
      license = lib.licenses.lgpl21Plus;
      platforms = lib.platforms.unix;
    };
  };

  pgquery-vala = stdenv.mkDerivation {
    pname = "pgquery-vala";
    version = "unstable-2024-04-18";

    src = fetchFromGitHub {
      owner = "ppvan";
      repo = "pg_query_vala";
      rev = "807ad2773c43c9415b361e15cf51422f5123406f";
      hash = "sha256-udgLxNVHStTky0MH40bxwfBgcGJCLfABCeqxsbn4bzg=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      vala
    ];

    buildInputs = [
      glib
      libpg_query
    ];

    postPatch = ''
      patchShebangs script.sh
    '';

    meta = {
      description = "Vala bindings for libpg_query";
      homepage = "https://github.com/ppvan/pg_query_vala";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "tarug";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ppvan";
    repo = "tarug";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k8ISI6hVjriJrSoNWr2Un2MvEss52X8j4pVPFEl93uQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    json-glib
    libgee
    gtksourceview5
    postgresql
    sqlite
    libpg_query
    libcsv
    pgquery-vala
  ];

  meta = {
    description = "Small tool for quick SQL queries, specialized in PostgreSQL";
    homepage = "https://github.com/ppvan/tarug";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "psequel";
  };
})
