{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  SDL2,
  openal,
  libGL,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "touchhle";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "touchHLE";
    repo = "touchHLE";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-UnXJdmG5P/tVp9CegvxzBUw9FOCZB/zvuWAS0vzfQ7Y=";
  };

  patches = [
    # Add a --keyboard-to-touch=KEY,X,Y option that maps a keyboard key to a
    # point on the simulated touch screen, mirroring --button-to-touch.
    ./patches/keyboard-to-touch.patch
  ];

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = {
      "sdl2-0.37.0" = "sha256-zHra4VwC2ARQzXoRKhi/r2uvOrjpDvCqumnRnhpmlNs=";
    };
  };

  # Use the SDL2 and OpenAL Soft shared libraries provided by the system
  # instead of statically linking the bundled copies (see dev-docs/building.md).
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    SDL2
    openal
    libGL
  ];

  # cmake is only used by the vendored C/C++ wrappers (dynarmic etc.) via their
  # build scripts, so the Rust package itself must not run cmake's configure
  # phase.
  dontUseCmakeConfigure = true;

  # Some vendored CMake projects still declare a pre-3.5 minimum version, which
  # modern CMake rejects. Allow them to configure anyway.
  env.CMAKE_POLICY_VERSION_MINIMUM = "3.5";

  # touchHLE looks up its bundled resources relative to the current directory.
  # Point the resource path constants at the absolute install location so the
  # emulator works from any working directory, while user data (apps, sandbox,
  # options) stays relative to the user's current directory as upstream intends.
  postPatch = ''
    substituteInPlace src/paths.rs \
      --replace-fail '"touchHLE_dylibs"' '"'"$out"'/share/touchHLE/touchHLE_dylibs"' \
      --replace-fail '"touchHLE_fonts"' '"'"$out"'/share/touchHLE/touchHLE_fonts"' \
      --replace-fail '"touchHLE_default_options.txt"' '"'"$out"'/share/touchHLE/touchHLE_default_options.txt"'
  '';

  # The integration test suite compiles a guest test app with a specific
  # prebuilt Clang toolchain that isn't available here (see tests/README.md).
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/touchHLE
    cp -r touchHLE_dylibs touchHLE_fonts touchHLE_default_options.txt $out/share/touchHLE/
  '';

  meta = {
    description = "High-level emulator for iPhone OS applications";
    homepage = "https://touchhle.org/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "touchHLE";
  };
})
