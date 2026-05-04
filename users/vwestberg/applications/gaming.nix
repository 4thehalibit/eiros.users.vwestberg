{ pkgs, ... }:
let
  winboat-connect = pkgs.writeShellScriptBin "winboat-connect" ''
    port=$(${pkgs.docker}/bin/docker inspect WinBoat 2>/dev/null \
      | ${pkgs.python3}/bin/python3 -c "
import json, sys
d = json.load(sys.stdin)
if not d: exit(1)
ports = d[0].get('NetworkSettings', {}).get('Ports', {})
bindings = ports.get('3389/tcp', [])
if bindings: print(bindings[0]['HostPort'])
" 2>/dev/null)
    if [ -z "$port" ]; then
      echo "WinBoat container not running. Start it from the WinBoat app first."
      exit 1
    fi
    exec ${pkgs.freerdp}/bin/wlfreerdp \
      /v:127.0.0.1:"$port" \
      /u:vwestberg \
      /p:vwestberg \
      /dynamic-resolution \
      /gfx \
      +clipboard \
      /cert:ignore \
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
