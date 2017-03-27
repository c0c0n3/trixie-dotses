#
#
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.gnomix.gsettings.script.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        TODO
      '';
    };
    ext.gnomix.gsettings.script.cmd-name = mkOption {
      type = string;
      default = "gnomix-settings.load";
      description = ''
        The name of the script to load the settings.
      '';
    };
    ext.gnomix.gsettings.script.lines = mkOption {
      type = attrsOf string;
      default = {};
      description = ''
        The lines that make up the script. Each module adds its specific bits.
      '';
    };
    ext.gnomix.gsettings.script.xdg-data-dirs = mkOption {
      type = listOf package;
      default = [];
      description = ''
        The packages containing the GSettings schemas that have to be available
        to the gsettings for it to be able to set values in the config DB.
        Each module adds packages depending on what settings they use in the
        lines option.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings.script;
    enabled = cfg.enable;

    bash = "${pkgs.bashInteractive}/bin/bash";

    schema-path = pkg : "/run/current-system/sw/share/gsettings-schemas/" +
                        "${pkg.name}";  # NOTE (2) (3)
    xdg-data-dirs = concatMapStringsSep ":" schema-path
                      (unique cfg.xdg-data-dirs);

    script = pkgs.writeScriptBin cfg.cmd-name ''
      #!${bash}

      export XDG_DATA_DIRS="${xdg-data-dirs}"

      ${concatStringsSep "\n" (attrValues cfg.lines)}
    '';
  in (mkIf enabled {
    environment.systemPackages = [ script ];
  });

}
