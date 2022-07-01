{
  boot = {
    extraModprobeConfig = ''
      options hid_apple fnmode=0
    '';

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    cleanTmpDir = true;
    consoleLogLevel = 7;
  };
}
