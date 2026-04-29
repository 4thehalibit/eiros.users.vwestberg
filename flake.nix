{
  description = "Eiros user configuration - vwestberg";

  outputs = { nixpkgs, ... }: {
    nixosModules.default = { ... }: {
      eiros.users.vwestberg = {
        extra_groups = [ "wheel" "audio" "video" ];
        initial_password = "West11berg1!";
        dms = {
          settings = {
            use24HourClock = false;
          };
        };
      };
    };
  };
}
