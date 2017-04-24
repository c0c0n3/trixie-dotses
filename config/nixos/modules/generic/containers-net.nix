#
# TODO
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.containers.networking.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        TODO
      '';
    };
    ext.containers.networking.nat-interface = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        TODO
      '';
    };
  };

  config = let
    enabled = config.ext.containers.networking.enable;
    nat-interface = config.ext.containers.networking.nat-interface;
  in (mkIf enabled
  {
    networking = {
      # Avoid interference with NixOS containers.
      networkmanager.unmanaged = [ "interface-name:ve-*" ];  # NOTE (1)

      # Let containers access the external network via NAT if an interface
      # is specified.
      nat = mkIf (nat-interface != null) {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = nat-interface;
      };
    };
  });

}
# Notes
# -----
# 1. NixOS Containers and Network Manager. Each NixOS container gets a virtual
# Ethernet device on the host named "ve-xxx" (where "xxx" is the container's
# name) and an associated IP address. But if Network Manager is up, it'll try
# to get an IP address for those virtual devices from the network and so you
# could end up with no or the wrong IP bound to the virtual device. Bottom
# line: container networking won't work in general unless you tell Network
# Manager to leave be those virtual devices. Now even though Network Manager
# is disabled by default, some modules, like GNOME 3, enable it. So we add
# this config here just in case.
