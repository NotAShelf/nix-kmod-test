Experimental.

```bash
$ nixos-rebuild build-vm --flake .#gamma --builders ""

# While logged in
$ modprobe -r test # test is loaded by default, remove it

# To load it back
$ modprobe test # load previously unloaded `test` module
```

## Notes

NixOS/Nixpkgs documentation on building Linux kernels or kernel modules is
_really_ poor. You get little to no information for anything
non-conventional[^1].

### Sources

- [Fun read on writing your own kernel modules](https://blog.sourcerer.io/writing-a-simple-linux-kernel-module-d9dc3762c234)
- [Nixpkgs manual on building kernel modules](https://nixos.org/manual/nixpkgs/stable/#sec-linux-kernel-developing-modules)
  (7 lines)

[^1]:
    "Conventional" is doing some heavy-lifting here. A lot of the things done
    here are conventional _and_ idiomatic.
