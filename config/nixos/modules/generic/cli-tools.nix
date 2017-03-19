#
# Installs a collection of useful command line tools and enables Bash
# completion.
# See below for what gets installed.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.cli-tools.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable this to install a collection of useful command line tools.
      '';
    };
  };

  config = mkIf config.ext.cli-tools.enable
  {
    # Enable Bash completion.
    programs.bash.enableCompletion = true;

    # Install useful tools.
    environment.systemPackages = with pkgs; [
    # Internet:
      aria
    # Hardware:
      hwinfo pciutils usbutils
    # Disk:
      parted hdparm sdparm smartmontools
    # Filesystems:
      ntfs3g
    # Network:
      ethtool tcpdump ldns ncat  # NOTE (1)
    # Commands:
      tree bc lsof mkpasswd lesspipe
    # Compression: (they all work with lesspipe)
      fastjar unzip zip # unrar cdrkit
                        # NOTE (2) (3)
    # Version Control
      git
    ] ++
    # Monitor
    (if config.services.xserver.enable then
      [ xorg.xdpyinfo xorg.xev xorg.xmodmap ]
      else []);
  };

}
# Notes
# -----
# 1. dnsutils. Couldn't find it in the NixOS packages and indeed Arch ditched
# it too:
# - https://www.archlinux.org/todo/dnsutils-to-ldns-migration/
# So I'm installing ldns---so use drill instead of nslookup/dig, etc.
#
# 2. unrar. It doesn't have a freeware license so Nix won't install it unless
# you set
#
#     nixpkgs.config.allowUnfree = true;
#
# I've hardly ever used unrar, so am not going to install it.
#
# 3. cdrkit. Not going to install it. Who's using CDs anymore these days?
