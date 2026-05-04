{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  environment.systemPackages = [
    pkgs.uxplay
  ];
}
