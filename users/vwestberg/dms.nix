{ config, ... }:
let
  overrides =
    if builtins.pathExists ../../dms-overrides.json
    then builtins.fromJSON (builtins.readFile ../../dms-overrides.json)
    else { };
in
{
  eiros.users.vwestberg.dms.settings =
    config.eiros.system.user_defaults.dms._settings // overrides;
}
