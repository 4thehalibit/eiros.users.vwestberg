# eiros.users.vwestberg

Personal NixOS user configuration for vwestberg. Part of the [eiros](https://github.com/4thehalibit) system configuration.

## Structure

```
users/
└── vwestberg/
    ├── user.nix              # User account settings (password set here)
    ├── groups.nix            # Group memberships
    ├── trusted_user.nix      # Nix trusted user settings
    ├── mangowc.nix           # MangoWC overlay config
    └── applications/         # Per-app NixOS module configs
```

## First-Time Setup

Before installing, you need to set your password in `users/vwestberg/user.nix`.

1. Generate a password hash:
   ```bash
   mkpasswd -m yescrypt
   ```

2. Open `users/vwestberg/user.nix` and replace `REPLACE_WITH_HASH` with the output.

3. Commit and push the change — the hash is a one-way value, safe to store in a public repo.
   ```bash
   git add users/vwestberg/user.nix
   git commit -m "Set password hash"
   git push
   ```

## Using This as a Template

If you want to use this config for your own user:

1. Fork the repo
2. Rename `users/vwestberg/` to your username
3. Update all references to `vwestberg` inside the nix files
4. Follow the First-Time Setup steps above
