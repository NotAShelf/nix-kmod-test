let
  inherit (builtins) currentSystem getFlake;
  flake = getFlake ("git+file://" + toString ../.);

  inherit (flake.inputs) nixpkgs;
  pkgs = nixpkgs.legacyPackages.${currentSystem};

  inherit (flake.outputs.packages.${currentSystem}) kernel;
  fhs = pkgs.buildFHSEnv {
    # Construct a FHS shell to be used for kernel module building
    # in a desirable environment. `nix-shell` followed by `make`
    # will build the module for you.
    name = "linux-dev-fhs-env";
    targetPkgs = pkgs:
      (kernel.dev.nativeBuildInputs or []) ++ [pkgs.gcc pkgs.gnumake];

    # Tell Make to look into the correct directory for the build. There might
    # be a better way to do this, but I am not aware of it.
    runScript = pkgs.writeScript "init.sh" ''
      export KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
      export INSTALL_MOD_PATH=${builtins.placeholder "out"}
      exec bash
    '';
  };
in
  fhs.env
