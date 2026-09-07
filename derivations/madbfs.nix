{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fuse3,
  android-tools,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "madbfs";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/mrizaln/madbfs/releases/download/v${finalAttrs.version}/madbfs.tar.gz";
    hash = "sha256-a7eszgDoTEf2TkXfoga3+nOPfZTHi4Be37v8kPWst3c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # autoPatchelfHook picks up libstdc++/libgcc_s from stdenv; fuse3 is
  # dlopen'd at runtime so it must be in LD_LIBRARY_PATH rather than NEEDED.
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 madbfs     $out/bin/madbfs
    install -Dm755 madbfs-msg $out/bin/madbfs-msg

    wrapProgram $out/bin/madbfs \
      --prefix PATH            : ${lib.makeBinPath [ android-tools ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ fuse3 ]}

    runHook postInstall
  '';

  meta = {
    description = "Userspace filesystem for Android via adb built using libfuse";
    longDescription = ''
      madbfs (modern adb filesystem) mounts your Android device as a FUSE
      filesystem. It supports full file/directory traversal, concurrent
      streaming I/O, partial read/write, and an optional native proxy server
      for better throughput — all without requiring root on the device.
    '';
    homepage = "https://github.com/mrizaln/madbfs";
    changelog = "https://github.com/mrizaln/madbfs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "madbfs";
  };
})
