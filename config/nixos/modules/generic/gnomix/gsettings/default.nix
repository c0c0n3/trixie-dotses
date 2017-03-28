#
# TODO
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../../../../pkgs;
with import ./utils.nix;
{

  imports = [
    ./key-bindings.nix
    ./look-n-feel.nix
    ./script.nix
  ];

  options = {
    ext.gnomix.gsettings.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        TODO
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings;
  in (mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; with gnome3; [
      # glib glib.dev
      # gsettings_desktop_schemas
      gnome-shell-extensions # TODO ???
      # flat-remix-gnome-theme
    ];

    ext.gnomix.shell.extensions.enable = true;

    ext.gnomix.shell.extensions.user-theme.enable = true;
    #ext.gnomix.shell.extensions.user-theme.name = "xxxx";
    ext.gnomix.shell.extensions.user-theme.package = flat-remix-gnome-theme;

    ext.gnomix.shell.extensions.packages = [
      shelltile dynamictopbar
    ];
    ext.gnomix.shell.extensions.uuids = [
      "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    ];

    # ext.gnomix.gsettings.script.enable = true;
  });

}
