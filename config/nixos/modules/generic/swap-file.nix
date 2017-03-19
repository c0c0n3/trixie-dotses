#
# Enables swapping on a swap file.
# The default file is `/swapfile` and has a size of 1 GiB.
# Under the hood, we automatically tweak kernel parameters for "swappiness".
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.swapfile.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables using a swap file.
      '';
    };
    ext.swapfile.pathname = mkOption {
      type = string;
      default = "/swapfile";
      description = ''
        Path to the swap file.
      '';
    };
    ext.swapfile.size = mkOption {
      type = int;
      default = 1024;
      description = ''
        The size, in MiB, of the swap file.
      '';
    };
  };

  config = let
    enabled = config.ext.swapfile.enable;
    file = config.ext.swapfile.pathname;
    sz = config.ext.swapfile.size;
  in
  {

    swapDevices = mkIf enabled [{
      device = file;
      size = sz;
    }];

    boot.kernel.sysctl = mkIf enabled {
      "vm.swappiness" = 1;
      "vm.vfs_cache_pressure" = 50;
    };

  };

}
