#
# Main module for `madell` config.
#
{ config, lib, pkgs, ... }:

let
  adminName = "andrea";

  my-nodejs = pkgs.nodejs.overrideAttrs (oldAttrs: rec {
    version = "6.10.2";
    src = pkgs.fetchurl {
      url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1dj6x35r9jsfs4g77h35yrimpgn62chnwr4r7abi76597lri3al0";
    };
  });
in
{

  imports = [
    ../../modules/dotses
    ../../modules/generic
    ../../pkgs
    ./hidpi.nix
  ];

  ##########  Core System Setup  ###############################################

  # Set hostname and enable swap.
  networking.hostName = "madell";
  networking.firewall.enable = false;
  ext.swapfile.enable = true;

  # Hide boot loader menu. The loader will boot the latest NixOS generation.
  # NB you won't be able to rollback to an earlier NixOS generation at boot.
  boot.loader.timeout = 0;

  # VBox setup:
  # - enable virtualbox guest service (even though hardware-configuration.nix
  #   enables it already, we add it here too to make it more visible)
  # - skip fsck on boot cos it won't work with VBox
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  # Tweak resolution to take advantage of the retina display on my mactop.
  ext.hidpi.enable = true;

  ##########  Desktop Setup  ###################################################

  # Create my usual admin user with initial password of `abc123` and build
  # a bare-bones desktop for him, with automatic login.
  ext.youdesk = {
    enable = true;
    username = adminName;
  };

  # Make my admin user a member of the Vbox group too and set up my usual
  # VBox shares for him.
  ext.vbox-shares = {
    names = [ "dropbox" ]; # "github" "playground" "projects" ];
    username = adminName;
  };

  # Make my admin use my git config.
  ext.git.config.user = config.users.extraUsers.andrea;

  # Tweak Spacemacs font.
  ext.spacemacs.config.font = {
    size = 40;
    weight = "light";
  };

  ##########  Desktop Extras  ##################################################

  # Set any of the following to true to enable, see baredesk module.
  ext.baredesk = {
    with-browser = true;    # Use Chrome. NB requires allowUnfree.
    with-launcher = false;   # Use Synapse instead of dmenu.
    with-theme = false;      # Eye candy: Numix theme & icons.
    with-composite = false;  # Eye candy: Compton. NB slows things down in a VM.
  };

  ##########  Additional Software  #############################################

  # By default Nix won't install packages that have a non-free software
  # license. We need a couple of those (see notes down below) so we have
  # to override the default setting to force Nix to install them.
  nixpkgs.config.allowUnfree = true;

  # Install a fairly complete Haskell dev env.
  ext.haskell.dev = {
    enable = true;
    with-extra-hpkgs = ps: with ps; [
      here
      diagrams diagrams-graphviz
    ];
  };

  # Install Java and LaTeX dev environments.
  ext.java.dev.enable = true;
  ext.latex.dev.enable = true;

  environment.systemPackages = with pkgs; [
    graphviz  # needed by diagrams-graphviz

    stack     # see NOTE (1)
    vscode    # requires allowUnfree; see NOTE (2)

    yarn
    my-nodejs
    awscli
  ];

}

# NOTE
# 1. Stack. Installs fine but then can't build GHC when you set up a project.
# In fact, Stack normally downloads and builds the GHC version tied to the LTS
# in your stack project config. With my Nix config this doesn't work since you
# need to have a number of things in your path to build GHC---gcc, gnumake, and
# probably others. Instead of installing GHC build deps globally, I decided to
# use the LTS snapshot corresponding to the GHC version installed globally by
# the Haskell dev env (ext.haskell.dev) and enable nix support in stack which
# makes it use the GHC in your path if it's compatible with the configured LTS.
#
# 2. Haskell IDE Engine (HIE): https://github.com/haskell/haskell-ide-engine
# Due to some issues, HIE isn't yet available as a Nix package, but they've
# provided an interim solution to install it through Nix:
#
#     $ git clone https://github.com/domenkozar/hie-nix.git
#     $ nix-env -f hie-nix -iA hie80
#
# (hie80 selects GHC 8.0.2, read the installation instructions for details.)
# I installed the "Haskell Language Server Client" plugin to integrate HIE
# into VS Code---installed using VS Code, not Nix.
# NB I'm using VS Code for Haskell development since Spacemacs started acting
# up and freezing when editing Haskell files.
