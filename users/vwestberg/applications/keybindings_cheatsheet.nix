{ pkgs, ... }:
{
  eiros.system.desktop_environment.dankmaterialshell.plugins.keybindingCheatSheet = {
    enable = true;
    src = pkgs.fetchFromGitHub {
      owner = "stvnwrgs";
      repo = "dms-keybindings-cheat-sheet";
      rev = "65ce39ae417e3a08374d028b08fc18bdcb0ba046";
      hash = "sha256-kK2LSdzNne/M3iBn7p3h5ZytqVoZLVyOczpokzFa+ew=";
    };
  };
}
