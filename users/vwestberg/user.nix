{ ... }:
{
  config = {
    eiros.users.vwestberg = {};
    # Generate your password hash with: mkpasswd -m yescrypt
    # Then replace the value below with your hash.
    users.users.vwestberg.initialHashedPassword = "REPLACE_WITH_HASH";
  };
}
