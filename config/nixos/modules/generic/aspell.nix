#
# Installs Aspell.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.aspell.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs Aspell.
      '';
    };
    ext.aspell.lang = mkOption {
      type = listOf string;
      default = [ "en" ];
      description = ''
        List of language codes to specify what dictionaries to install.
      '';
    };
  };

  config = let
    enabled = config.ext.aspell.enable;
    dicts = with pkgs; map (x: aspellDicts."${x}") config.ext.aspell.lang;
  in
  {
    environment.systemPackages = mkIf enabled (with pkgs; [aspell] ++ dicts);
  };

}
