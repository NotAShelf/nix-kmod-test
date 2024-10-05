{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages."${system}" = let
      inherit (pkgs.linuxPackages_latest) kernel;
      kmod = pkgs.callPackage ./nix/kmod.nix {inherit kernel;};
    in {
      inherit kernel kmod;
    };

    nixosConfigurations."gamma" = nixpkgs.lib.nixosSystem {
      modules = [
        ({
          modulesPath,
          config,
          lib,
          ...
        }: {
          imports = [(modulesPath + "/profiles/qemu-guest.nix")];
          networking.hostName = "gamma";

          boot = {
            growPartition = true;
            kernelParams = ["console=ttyAMA0,115200n8" "console=tty0"];
            consoleLogLevel = lib.mkDefault 7; # ground control to kernel
          };

          # Empty password
          users.extraUsers.root.initialHashedPassword = "";

          # Nixpkgs options
          nixpkgs.pkgs = pkgs; # discard everything else, follow flake `pkgs`

          # Packages
          environment.systemPackages = [pkgs.microfetch];

          # Bootable
          fileSystems."/boot" = {
            device = "/dev/vda1";
            fsType = "vfat";
          };

          fileSystems."/" = {
            device = "/dev/vda2";
            fsType = "ext4";
          };

          boot.loader.grub = {
            efiSupport = true;
            efiInstallAsRemovable = true;
            device = "nodev";
          };

          # Kernel fun
          boot = {
            # Use kernel package defined in flake.nix
            kernelPackages = pkgs.linuxPackagesFor self.packages.${system}.kernel; # exposed kernel

            # Get test module from flake outputs
            extraModulePackages = [self.packages.${system}.kmod];

            # Load module from package.
            # Alternatively, `$ modprobe test` would work too
            kernelModules = ["test"];
          };

          # Make it smaller
          documentation = {
            doc.enable = false;
            man.enable = false;
            nixos.enable = false;
            info.enable = false;
          };

          # Get out.
          programs = {
            bash.completion.enable = false;
            command-not-found.enable = false;
          };

          # Shut up.
          system.stateVersion = "24.11";
        })
      ];
    };
  };
}
