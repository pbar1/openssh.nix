# openssh.nix

Nix flake to compile OpenSSH.

```sh
nix run github:pbar1/openssh.nix -- --help
```

### Patches

- Allow `none` cipher to be selected.
  - **Warning:** This should be used for debug purposes only, _not_ in production.
