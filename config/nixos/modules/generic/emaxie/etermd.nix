#
# Emacs terminal daemon.
# A systemd user service to manage an Emacs daemon that should start
# terminal buffers (e.g. ansi-term) for its clients. We also set up
# a client wrapper script to make it easier to connect to the daemon
# and display a terminal buffer.
#
{ config, pkgs, lib, ... }:

with lib;
with types;

{ # adapted from emacs.nix

  options = {
    ext.etermd.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables a user service for the Emacs daemon.
      '';
    };
    ext.etermd.package = mkOption {
      type = package;
      default = pkgs.emacs;
      description = ''
        Emacs derivation to use for both the daemon and the client script.
      '';
    };
    ext.etermd.term-sexpr = mkOption {
      type = string;
      default = ''(ansi-term "bash")'';
      description = ''
        Emacs S-expression to start a terminal.
      '';
    };
    ext.etermd.daemon-name = mkOption {
      type = string;
      default = "etermd";
      description = ''
        Emacs daemon name. We use a name so that you can have other Emacs
        daemons running if you like. This is also the name we use to set
        up the systemd unit to run the daemon. (You can grab it from the
        systemd.user.services set and tweak it if you need to, e.g. adding
        environment variables.)
      '';
    };
    ext.etermd.client-cmd-name = mkOption {
      type = string;
      default = "etermd-client";
      description = ''
        The name of the command you want to use to start a terminal in the
        Emacs daemon. We'll build a wrapper script with that name and put
        it in your PATH.
      '';
    };
  };

  config = let
    cfg = config.ext.etermd;

    emacs = "${cfg.package}/bin/emacs";
    emacsclient = "${cfg.package}/bin/emacsclient";
    bash = "${pkgs.bashInteractive}/bin/bash";  # NOTE (1)
    daemon = ''exec ${emacs} --daemon="${cfg.daemon-name}"'';

    termScript = pkgs.writeScriptBin cfg.client-cmd-name ''
      #!${bash}
      exec ${emacsclient} --create-frame -s "${cfg.daemon-name}" \
                          --eval '${cfg.term-sexpr}'
    '';  # NOTE (2)

  in (mkIf cfg.enable
  {
    environment.systemPackages = [ termScript cfg.package ];

    systemd.user.services."${cfg.daemon-name}" = {
      description = "Emacs daemon: ${cfg.daemon-name}";

      serviceConfig = {
        Type      = "forking";
        ExecStart = ''
          ${bash} -c 'source ${config.system.build.setEnvironment}; ${daemon}'
        '';
        ExecStop  = "${emacsclient} --eval (kill-emacs)";
        Restart   = "always";
      };

      wantedBy = [ "default.target" ];  # NOTE (3)
    };
  });

}
# Notes
# -----
# 1. Shell. NixOS uses Bash all over the show so it's always available but
# I'm not sure what is the canonical way of using it. My gut feel is that
#
#   bash = "${pkgs.bashInteractive}/bin/bash";
#
# should be the standard way, but the two expressions below also work
#
#   bash = "${pkgs.bash}/bin/bash";
#   bash = pkgs.stdenv.shell;
#
# and I've seen them used in NixOS modules, e.g. emacs.nix.
#
# 2. Emacs Client Alternate Editor. If you call emacsclient when no Emacs
# daemon's running, the program obviously spits out an error. But you could
# pass the `--alternate-editor` option to start a standalone Emacs if the
# client can't connect to the daemon. The reason why we don't use it in our
# client script is that the terminal won't start anyway. Try this when no
# Emacs daemon's running:
#
#     $ emacsclient --create-frame --alternate-editor emacs  \
#                   --eval '(ansi-term "bash")'
#
# You'll get a fresh Emacs instance with a buffer for editing the file...
# `(ansi-term "bash")`!?
#
# 3. Per-user Enabling of Service. Specifying this target means every logged-in
# user gets their own service instance. We could actually do better and only
# enable the service for the users who want it by creating sym-links in their
# homes, see
# - https://nixos.org/nixos/manual/#idm140737315629552
# Shouldn't actually be too difficult to add an option with a list of users
# and then activate the service just for them...
