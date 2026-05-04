{ pkgs, ... }:
let
  winboat-connect = pkgs.writeShellScriptBin "winboat-connect" ''
    exec ${pkgs.freerdp}/bin/wlfreerdp \
      /v:127.0.0.1:47300 \
      /u:vwestberg \
      /p:vwestberg \
      /dynamic-resolution \
      /gfx \
      +clipboard \
      /sound:sys:alsa \
      /microphone:sys:alsa \
      2>/dev/null
  '';

  winboat-connect-desktop = pkgs.writeTextFile {
    name = "winboat-connect-desktop";
    destination = "/share/applications/winboat-connect.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Windows (WinBoat)
      Comment=Connect to WinBoat Windows VM
      Exec=winboat-connect
      Icon=computer
      Categories=System;
    '';
  };
in
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.winboat
    pkgs.freerdp
    winboat-connect
    winboat-connect-desktop
  ];
}
