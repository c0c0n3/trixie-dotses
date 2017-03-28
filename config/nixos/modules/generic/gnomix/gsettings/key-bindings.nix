#
# GNOME 3 key bindings.
# Any config option below can be null in which case it's ignored. If you want
# to clear the corresponding setting in the GNOME config DB, set the option to
# an empty string or list as the case may be.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ./utils.nix;
{
  # TODO get rid of default values. move default config to gnomix/default.nix?

  options = {
    ext.gnomix.gsettings.keys.switch-to-workspace = mkOption {
      type = nullOr string;
      default = "<Super>";
      description = ''
        Key combination to switch to workspaces 1 to 10. We generate 10 key
        sequences: "k1", ..., "k9", "k0" where "k" is the value you set. Then
        we bind each key sequence to the "switch to workspace n" command with
        n = 1, ..., 10. So hitting the "k1" combination switches to the first
        workspace, ..., "k9" to the 9th, and "k0" to the 10th.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-workspace = mkOption {
      type = nullOr string;
      default = "<Super><Shift>";
      description = ''
        Key combination to move to workspaces 1 to 10. We generate 10 key
        sequences: "k1", ..., "k9", "k0" where "k" is the value you set. Then
        we bind each key sequence to the "move to workspace n" command with
        n = 1, ..., 10. So hitting the "k1" combination moves to the first
        workspace, ..., "k9" to the 9th, and "k0" to the 10th.
      '';
    };
    ext.gnomix.gsettings.keys.close = mkOption {
      type = nullOr string;
      default = "<Super><Shift>k";
      description = ''
        Key combination to close a window.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings.keys;

    # builds this set: { k1 = [v1]; ...; k9 = [v9]; k10 = [v0]; }
    # but if v == null, then k1 = null, ..., k10 = null.
    mk-set = k : v :
    let
      mk-key = i : "${k}${toString i}";
      mk-val = i : if v != null then [ "${v}${toString i}" ] else null;

      ks = map mk-key (range 1 10);
      vs = map mk-val ((range 1 9) ++ [0]);
    in
      listToAttrs (zipListsWith nameValuePair ks vs);

    script = setIfFragment "Key bindings" ({
      "org.gnome.desktop.wm.keybindings close" = [ cfg.close ];
    } // (mk-set "org.gnome.desktop.wm.keybindings switch-to-workspace-"
                 cfg.switch-to-workspace)
      // (mk-set "org.gnome.desktop.wm.keybindings move-to-workspace-"
                 cfg.move-to-workspace));
    /*
    script = ''
      # Hard-coded key bindings
      for i in {1..10}
      do
        ${set} org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$((i % 10))']"
        ${set} org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$((i % 10))']"
      done
      ${set} org.gnome.desktop.wm.keybindings close "['<Super><Shift>k']"
    '';
    */
  in {  # NOTE (1)
    # Add a fragment to the gsettings script to store our settings into the
    # GNOME config DB.
    ext.gnomix.gsettings.script.lines.key-bindings = script;

    # Specify the schema gsettings is going to need to set our config values.
    ext.gnomix.gsettings.script.xdg-data-dirs = with pkgs.gnome3; [
      gsettings_desktop_schemas
    ];
  };

}
# Notes
# -----
# 1. Enabling Config. Pointless to add an "enabled" check here. Blindly add
# lines to the script: if gsettings.enable == false nothing happens.
