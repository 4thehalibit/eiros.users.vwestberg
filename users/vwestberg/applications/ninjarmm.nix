{ pkgs, ... }:
let
  ncplayer = pkgs.stdenv.mkDerivation {
    pname = "ninjarmm-ncplayer";
    version = "13.35.8340";

    src = builtins.path {
      path = /home/vwestberg/Downloads/ninjarmm-ncplayer-13.35.8340_amd64.deb;
      name = "ninjarmm-ncplayer.deb";
    };

    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      libdrm
      mesa
      dbus
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      dpkg-deb --extract $src .
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp opt/ncplayer/bin/ncplayer $out/bin/
      substitute usr/share/applications/ninjarmm-ncplayer.desktop \
        $out/share/applications/ninjarmm-ncplayer.desktop \
        --replace "/opt/ncplayer/bin/ncplayer" "$out/bin/ncplayer"
    '';
  };
in
{
  config.environment.systemPackages = [ ncplayer ];
}
