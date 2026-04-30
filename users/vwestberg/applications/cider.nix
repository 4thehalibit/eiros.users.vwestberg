{ pkgs, ... }:
{
  config.environment.systemPackages = [ pkgs.cider-2 ];
}
