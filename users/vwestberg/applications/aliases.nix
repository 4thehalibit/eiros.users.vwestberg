{ ... }:
{
  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/tmp/eiros#default' --override-input eiros_users '/home/vwestberg/eiros-config' --override-input eiros_hardware 'github:4thehalibit/eiros.hardware.vwestberg'";
    deploy = "cd ~/eiros-config && git add -A && git commit -m 'update config' && git push && rebuild";
  };
}
