{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);

  # GI typelib search path for GTK4 + libadwaita
  giPath = builtins.concatStringsSep ":" (map (p: "${p}/lib/girepository-1.0") (with pkgs; [
    glib
    gtk4
    libadwaita
    pango
    gdk-pixbuf
    at-spi2-core
  ]));

  script = pkgs.writeShellScriptBin "dms-settings" ''
    export GI_TYPELIB_PATH="${giPath}''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
    exec ${pythonEnv}/bin/python3 ${./dms_settings.py} "$@"
  '';

  dms-settings = pkgs.symlinkJoin {
    name = "dms-settings";
    paths = [
      script
      (pkgs.makeDesktopItem {
        name = "dms-settings";
        desktopName = "DMS Settings";
        comment = "Configure DankMaterialShell";
        exec = "${script}/bin/dms-settings";
        icon = "preferences-system";
        categories = [ "Settings" ];
        terminal = false;
      })
    ];
  };
in
{
  environment.systemPackages = [ dms-settings ];
}
