Nix expressions for ROOT
========================

The aim of this repository is to provide Nix expressions for versions of ROOT needed by CDMS.

Install Method 1
================
The directory `root-local` contains files for a "local package" install.  This is probably better than the method below - instrutions pending.

Install Method 2
================
The directory `root-nixpkgs` contains files for installers who are willing to alter the Nix expressions originally installed as part of Nix.  

1. Copy the files in `root-nixpkgs` to wherever Nix has installed the ROOT expression.  On my machine, this looked like

```
$ cp root-nixpkgs/*.* ~/.nix-defexpr/channels/nixpkgs/pkgs/applications/science/misc/root/
```

2. Move to a directory outside of your $NIX_PATH (for real.  The build will fail if you're within $NIX_PATH, but it will take a really long time to do so.)

3. Build your custom ROOT expression with

```
$ nix-build '<nixpkgs>' -A root
```
4. If the expression builds successfully, a `result` directory will appear in the directory from which you invoked `nix-build`.  You can run ROOT with

```
$ result/bin/root
```
5.  Apparently you can also "install" ROOT with `nix-env -i ./result`.  I haven't tried this.
