{ ... }:
{
  programs.ninjaone = {
    enable = true;
    deb_path = /nix/store/hpwnxc53dn2f94qgcgmasrmv7649n6qf-ninjarmm-ncplayer_amd64.deb;
    update_alias.enable = true;
  };
}
