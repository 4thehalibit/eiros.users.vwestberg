{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  virtualisation.waydroid.enable = true;

  # Patch waydroid to skip iptables-legacy (missing kernel module on this kernel)
  # and fall back to iptables-nft which works via the loaded nf_tables/nf_nat modules.
  nixpkgs.overlays = [
    (final: prev: {
      waydroid = prev.waydroid.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/lib/waydroid/data/scripts/.waydroid-net.sh-wrapped \
            --replace 'IPTABLES_BIN="$(command -v iptables-legacy)"' 'IPTABLES_BIN=""' \
            --replace 'IP6TABLES_BIN="$(command -v ip6tables-legacy)"' 'IP6TABLES_BIN=""'
        '';
      });
    })
  ];
}
