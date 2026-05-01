{ ... }:
{
  eiros.system.nix.sources = {
    users.url = "github:4thehalibit/eiros.users.personal";
    hardware.url = "github:4thehalibit/eiros.hardware.framework16";
  };

  environment.variables.NH_FLAKE = "github:lcleveland/eiros";
}
