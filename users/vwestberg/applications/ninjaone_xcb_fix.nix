{ pkgs, lib, ... }:
let
  ncplayer-xcb = pkgs.writeShellScriptBin "ncplayer-xcb" ''
    export QT_QPA_PLATFORM=xcb
    export DISPLAY="''${DISPLAY:-:0}"
    export WAYLAND_DISPLAY="''${WAYLAND_DISPLAY:-wayland-0}"
    exec ncplayer "$@"
  '';

  ncplayer-desktop = pkgs.writeTextFile {
    name = "ninjarmm-ncplayer-xcb-desktop";
    destination = "/share/applications/ninjarmm-ncplayer-xcb.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=NinjaOne Remote Player
      Exec=ncplayer-xcb %u
      StartupNotify=false
      MimeType=x-scheme-handler/ninjarmm;
    '';
  };
in
{
  environment.systemPackages = [ ncplayer-xcb ncplayer-desktop ];

  xdg.mime.defaultApplications = lib.mkForce {
    "x-scheme-handler/ninjarmm" = "ninjarmm-ncplayer-xcb.desktop";
  };
}
