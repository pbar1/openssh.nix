{
  description = "Nix flake to compile OpenSSH";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      # Each of the targets that can be cross-compiled to
      buildTargets = {
        "x86_64-linux" = {
          crossSystemConfig = "x86_64-unknown-linux-musl";
        };

        "aarch64-linux" = {
          crossSystemConfig = "aarch64-unknown-linux-musl";
        };

        "x86_64-darwin" = {
          crossSystemConfig = "x86_64-apple-darwin";
        };

        "aarch64-darwin" = {
          crossSystemConfig = "aarch64-apple-darwin";
        };
      };

      # eachSystem [system] (system: ...)
      #
      # Returns an attrset with a key for every system in the given array, with
      # the key's value being the result of calling the callback with that key.
      eachSystem =
        supportedSystems: callback:
        builtins.foldl' (overall: system: overall // { ${system} = callback system; }) { } supportedSystems;

      # eachCrossSystem [system] (buildSystem: targetSystem: ...)
      #
      # Returns an attrset with a key "$buildSystem.cross-$targetSystem" for
      # every combination of the elements of the array of system strings. The
      # value of the attrs will be the result of calling the callback with each
      # combination.
      #
      # There will also be keys "$system.default", which are aliases of
      # "$system.cross-$system" for every system.
      eachCrossSystem =
        supportedSystems: callback:
        eachSystem supportedSystems (
          buildSystem:
          builtins.foldl' (
            inner: targetSystem:
            inner
            // {
              "cross-${targetSystem}" = callback buildSystem targetSystem;
            }
          ) { default = callback buildSystem buildSystem; } supportedSystems
        );

      mkPkgs =
        buildSystem: targetSystem:
        import nixpkgs (
          {
            system = buildSystem;
          }
          // (
            if buildSystem == targetSystem then
              { }
            else
              {
                # The nixpkgs cache doesn't have any packages where cross-compiling has
                # been enabled, even if the target platform is actually the same as the
                # build platform (and therefore it's not really cross-compiling). So we
                # only set up the cross-compiling config if the target platform is
                # different.
                crossSystem.config = buildTargets.${targetSystem}.crossSystemConfig;
              }
          )
        );
    in
    {
      packages =
        eachCrossSystem (builtins.attrNames buildTargets) (
          buildSystem: targetSystem:
          let
            pkgs = mkPkgs buildSystem null;
            pkgsCross = mkPkgs buildSystem targetSystem;

          in
          pkgsCross.openssh.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ ./patches/openssh-enable-none-cipher.patch ];
          })
        )
        // {
          # FIXME: Refactor cross above so that docker image packages are easier to add
        };
    };
}
