{ pkgs, ... }:
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
  ];
}
