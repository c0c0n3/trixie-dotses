#
# Installs a Java dev env with Open JDK, Gradle and Intellij Idea.
# Also sets JAVA_HOME globally.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.java.dev.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs a Java dev env.
      '';
    };
  };

  config = mkIf config.ext.java.dev.enable
  {
    environment.systemPackages = with pkgs; [
      jdk gradle idea.idea-community
    ];
    environment.variables = {
      JAVA_HOME = "${pkgs.jdk}";
    };
  };

}
# Notes
# -----
# You may be better off using nix-shell to manage dev profiles instead of
# installing globally. E.g. use this Nix expression to get an isolated dev
# env that is the same as the above:
/*

with import <nixpkgs> {}; {
  java-env = stdenv.mkDerivation {
    name = "java-env";
    JAVA_HOME = "${jdk}";

    buildInputs = [ jdk gradle idea.idea-community ];
  };
}

*/
# Assuming you put it in java-dev.nix, you could just
#
#  $ nix-shell java-dev.nix -A java-env
#
# or if you like simple, rename to default.nix, so you can simply run
#
#  $ nix-shell .
#
