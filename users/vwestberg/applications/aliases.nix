{ ... }:
{
  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/tmp/eiros#default' --override-input eiros_users '/home/vwestberg/eiros-config' --override-input eiros_hardware 'github:4thehalibit/eiros.hardware.vwestberg'";
    deploy = "cd ~/eiros-config && git add -A && git commit -m 'update config' && git push && rebuild";
    update-ninja = "{ deb=\$(ls ~/Downloads/ninjarmm-ncplayer-*.deb 2>/dev/null | sort -V | tail -1) && [ -n \"\$deb\" ] && nix run nixpkgs#dpkg -- -x \"\$deb\" /home/vwestberg/.local/opt/ncplayer && echo \"Updated from \$deb\" || echo 'No ninjarmm-ncplayer*.deb found in ~/Downloads'; }";
  };
}
