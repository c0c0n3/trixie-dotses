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

  options = {
    ext.gnomix.gsettings.keys.switch-to-workspace-down = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to switch to the next workspace down the stack.
      '';
    };
    ext.gnomix.gsettings.keys.switch-to-workspace-up = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to switch to the next workspace up in the stack.
      '';
    };
    ext.gnomix.gsettings.keys.switch-to-workspace = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Key combination to switch to workspaces 1 to 10. We generate 10 key
        sequences: "k1", ..., "k9", "k0" where "k" is the value you set. Then
        we bind each key sequence to the "switch to workspace n" command with
        n = 1, ..., 10. So hitting the "k1" combination switches to the first
        workspace, ..., "k9" to the 9th, and "k0" to the 10th.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-workspace = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Key combination to move to workspaces 1 to 10. We generate 10 key
        sequences: "k1", ..., "k9", "k0" where "k" is the value you set. Then
        we bind each key sequence to the "move to workspace n" command with
        n = 1, ..., 10. So hitting the "k1" combination moves to the first
        workspace, ..., "k9" to the 9th, and "k0" to the 10th.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-monitor-left = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to move to the monitor to the left.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-monitor-right = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to move to the monitor to the right.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-monitor-up = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to move to the monitor above.
      '';
    };
    ext.gnomix.gsettings.keys.move-to-monitor-down = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to move to the monitor below.
      '';
    };
    ext.gnomix.gsettings.keys.close = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to close a window.
      '';
    };
    ext.gnomix.gsettings.keys.maximize = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to maximise a window.
      '';
    };
    ext.gnomix.gsettings.keys.unmaximize = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to restore a window.
      '';
    };
    ext.gnomix.gsettings.keys.minimize = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''
        List of key combinations to minimise a window.
      '';
    };
    ext.gnomix.gsettings.keys.custom = mkOption {
      type = nullOr (listOf attrs);
      default = null;
      description = ''
        List of custom key bindings.
        Each set in the list looks like this:

            {
              name = "your binding name";
              command = "some-app-you-like";
              binding = "?";  # whatever key combination suits you
            }
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

    script1 = setIfFragment "Key bindings" ({  # NOTE (2) (3)
      "org.gnome.desktop.wm.keybindings maximize" =
                 cfg.maximize;
      "org.gnome.desktop.wm.keybindings unmaximize" =
                 cfg.unmaximize;
      "org.gnome.desktop.wm.keybindings minimize" =
                 cfg.minimize;
      "org.gnome.desktop.wm.keybindings close" =
                 cfg.close;
      "org.gnome.desktop.wm.keybindings move-to-monitor-up" =
                 cfg.move-to-monitor-up;
      "org.gnome.desktop.wm.keybindings move-to-monitor-down" =
                 cfg.move-to-monitor-down;
      "org.gnome.desktop.wm.keybindings move-to-monitor-right" =
                 cfg.move-to-monitor-right;
      "org.gnome.desktop.wm.keybindings move-to-monitor-left" =
                 cfg.move-to-monitor-left;
      "org.gnome.desktop.wm.keybindings switch-to-workspace-down" =
                 cfg.switch-to-workspace-down;
      "org.gnome.desktop.wm.keybindings switch-to-workspace-up" =
                 cfg.switch-to-workspace-up;
    } // (mk-set "org.gnome.desktop.wm.keybindings switch-to-workspace-"
                 cfg.switch-to-workspace)
      // (mk-set "org.gnome.desktop.wm.keybindings move-to-workspace-"
                 cfg.move-to-workspace));

    # Build another script fragment for the custom key bindings.
    # NOTE (2)

    custom-ref = i :
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" +
      "custom${toString i}/";

    custom-key = i : k :
      "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" +
      "${custom-ref i} ${k}";

    custom-key-setters = i : v : [
      (setIf v.name    (custom-key i "name"))
      (setIf v.command (custom-key i "command"))
      (setIf v.binding (custom-key i "binding"))
    ];

    custom-ref-setter = cs :
      setIf (imap (i : x : custom-ref i) cs)
            "org.gnome.settings-daemon.plugins.media-keys custom-keybindings";

    script2 = if cfg.custom == null then ""
              else unlines (
                     (concatLists (imap custom-key-setters cfg.custom)) ++
                     [ (custom-ref-setter cfg.custom) "" ]);
  in {  # NOTE (1)
    # Add a fragment to the gsettings script to store our settings into the
    # GNOME config DB.
    ext.gnomix.gsettings.script.lines.key-bindings = script1 + script2;

    # Specify the schema gsettings is going to need to set our config values.
    ext.gnomix.gsettings.script.xdg-data-dirs = with pkgs.gnome3; [
      gsettings_desktop_schemas gnome_settings_daemon
    ];
  };

}
# Notes
# -----
# 1. Enabling Config. Pointless to add an "enabled" check here. Blindly add
# lines to the script: if gnomix.config.enable == false nothing happens.
#
# 2. Null values. The scriptFragment function skips them, so if null, the
# option's value isn't set in the GNOME DB.
#
# 3. Custom Key Bindings. Not as straightforward as the others, also cos it
# seems you have to use a "relocatable" schema. Before you can make any sense
# of my code, you'll have to read:
# - https://community.linuxmint.com/tutorial/view/1171
# - https://wiki.ubuntu.com/Keybindings
#
# 4. Testing. This is how I used to whip the script together
#
#   script = ''
#     # Hard-coded key bindings
#     for i in {1..10}
#     do
#       ${set} org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$((i % 10))']"
#       ${set} org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$((i % 10))']"
#     done
#     ${set} org.gnome.desktop.wm.keybindings close "['<Super><Shift>k']"
#   '';
#
# I'm leaving it here just in case it could come handy later for testing.
