{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.android-studio-module;
in
{
  options.android-studio-module = {
    enable = lib.mkEnableOption "Android Studio development environment";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.android_sdk.accept_license = true;

    allowedUnfreePackagesRegexs = [
      # Android Studio and all android-sdk-* wrapper packages
      "android.*"
      # Android SDK core tools (exact names from repo.json)
      "tools"
      "build-tools"
      "platform-tools"
      "cmdline-tools"
      "cmake"
      "emulator"
      "ndk"
      "ndk-bundle"
      "platforms"
      "sources"
      "skiaparser"
      # System images (all variants)
      "system-image-.*"
      # Extras and Google add-ons
      "extras-.*"
      "google_apis"
      "google_tv_addon"
    ];

    environment.systemPackages = with pkgs; [
      # android-studio-full includes a predefined SDK composition with
      # platforms 28-34, emulator, system images, and the NDK
      android-studio
      android-tools
    ];

    users.groups.kvm.members = [ "marijnk" ];
  };
}
