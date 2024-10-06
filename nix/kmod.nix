{
  lib,
  stdenv,
  linuxPackages_latest,
  kernel ? linuxPackages_latest.kernel,
  ...
}: let
  pname = "linux-test-module";
  version = kernel.version;
in
  stdenv.mkDerivation {
    inherit pname version;

    src = builtins.path {
      path = ../src;
      name = "${pname}-${version}";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = kernel.moduleBuildDependencies;
    passthru.kernel-version = version;

    makeFlags =
      (kernel.makeFlags or [])
      ++ [
        "KERNELRELEASE=${kernel.modDirVersion}"
        "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        "INSTALL_MOD_PATH=${builtins.placeholder "out"}"
      ];

    buildFlags = ["modules"];
    installTargets = ["modules_install"];

    meta = {
      description = "Kernel module test derivation";
      platforms = lib.platforms.linux;
    };
  }
