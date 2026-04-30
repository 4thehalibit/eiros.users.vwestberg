{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.wlr-randr ];

  programs.zsh.shellAliases = {
    rebuild = "{ [ -d /tmp/eiros ] || gh repo clone 4thehalibit/eiros /tmp/eiros; } && sudo nixos-rebuild switch --impure --flake '/tmp/eiros#default' --override-input eiros_users '/home/vwestberg/eiros-config' --override-input eiros_hardware 'github:4thehalibit/eiros.hardware.vwestberg'";
    deploy = "cd ~/eiros-config && git add -A && git commit -m 'update config' && git push && rebuild";
    fixhdmi = "wlr-randr --output DP-7 --off && sleep 2 && wlr-randr --output DP-7 --on";
    claude = "cd ~/claude && command claude";
  };
}
