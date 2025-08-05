{
  lib,
  ...
}:
{
  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = true;

    # Commented options I found online, but seemingly aren't needed for quiet boot
    # consoleLogLevel = 3;
    # initrd.verbose = false;
    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      # "splash"
      # "boot.shell_on_fail"
      # "udev.log_priority=3"
      # "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # Workaround  https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # TODO: remove once fix lands in stable?
  systemd.services = {
    "autovt@tty1".enable = lib.mkForce false;
    "getty@tty1".enable = lib.mkForce false;
  };

}
