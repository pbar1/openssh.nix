# openssh.nix

Nix flake to compile OpenSSH.

To run:

```sh
nix run github:pbar1/openssh.nix -- --help
```

To build:

```sh
nix build github:pbar1/openssh.nix
```

### Patches

- Allow `none` cipher to be selected.
  - **Warning:** This should be used for debug purposes only, _not_ in production.
