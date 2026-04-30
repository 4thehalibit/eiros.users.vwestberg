{ ... }:
{
  config.security.sudo.extraRules = [
    {
      users = [ "vwestberg" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
