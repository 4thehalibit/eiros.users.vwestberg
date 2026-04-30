{ ... }:
{
  eiros.users.vwestberg.dms.settings = builtins.fromJSON (builtins.readFile ../../dms-settings.json);
}
