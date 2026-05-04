{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  virtualisation.waydroid.enable = true;

  # Use waydroid with nftables support — this kernel lacks the ip_tables legacy module
  # but has nf_tables/nf_nat loaded. The nixpkgs waydroid derivation has a built-in
  # nftables flag that patches LXC_USE_NFT=true in the network script.
  nixpkgs.overlays = [
    (final: prev: {
      waydroid = prev.waydroid.override { nftables = true; };
    })
  ];
}
