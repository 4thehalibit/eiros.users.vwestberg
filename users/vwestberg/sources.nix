{ ... }:
{
  eiros.system.nix.sources = {
    users.url = "github:4thehalibit/eiros.users.vwestberg";
    hardware.url = "github:4thehalibit/eiros.hardware.vwestberg";
  };

  environment.variables.NH_FLAKE = "github:lcleveland/eiros";
}
