#
# Preconfigured driver for Toshiba e-studio5005ac at the IGH.
# Usage:
#
#   services.printing.enable = true;
#   services.printing.drivers = [ (import ./pkgs/cups/toshiba-e-studio5005ac) ];
#
# Then you have to set up the printer with CUPS. The easiest is to use the
# built-in CUPS Web admin UI running at http://localhost:631/. The printer
# in the basement at IGH uses SMB, so when adding the printer use this URL
#
#  smb://andrea.falconi:***@IGH/fuji.igh.cnrs.fr/imp-ss
#
# replacing *** with your URL-encoded password. The URL format is
#
#  smb://username:password@domain/hostname/printer_name
#
# NOTE (1)
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "toshiba-e-studio5005ac";

  src = fetchurl {
    url = https://ssi.igh.cnrs.fr/upload/TOSHIBA_ColorMFP_RV_CUPS.tar;
    sha256 = "de027a3f573ce0569b0e7bf040af9d7b203381a1434829589382b926f690ec19";
  };

  buildInputs = [ cups ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    PPD_IN=share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS.gz
    PPD_OUT=TOSHIBA_ColorMFP_CUPS.gz
    original_filter_path=/usr/lib/cups/filter/est6550_Authentication
    nixos_filter_path=$out/lib/cups/filter/est6550_Authentication

    gzip -c -d $PPD_IN | \
    sed "s|$original_filter_path|$nixos_filter_path|g" | \
    gzip > $PPD_OUT

    PPD_DIR=$out/share/cups/model/Toshiba
    FILTER_DIR=$out/lib/cups/filter

    mkdir -p $PPD_DIR
    cp $PPD_OUT $PPD_DIR

    mkdir -p $FILTER_DIR
    cp lib/cups/filter/est6550_Authentication $FILTER_DIR
  '';
  # NOTE (2)
}
# Notes
# -----
# 1. SMB URL. It's potentially a security concern. In fact, even though CUPS
# removes the password from the URL when logging and display the printer
# settings in the UI, the original URL (with the password!) ends up in
# /etc/cups/printers.conf (DeviceURI section) which is only readable by
# root but I'd rather not have my password in a plain text config file...
#
# 2. Filter File. The path to it is hard-coded in TOSHIBA_ColorMFP_CUPS.gz
# so we have to Nixify it with the sed up there. Without changing the path
# the printer will moan about not being able to find:
# - /usr/lib/cups/filter/est6550_Authentication
#
# 3. Bugs. Even though the set up seems correct, CUPS still can't use this
# printer. The funny thing is that CUPS uses smbspool under the bonnet and
# if I run smbspool myself it works (* stands for my URL-encoded password)
#
#   $ DEVICE_URI=smb://andrea.falconi:*@IGH/fuji.igh.cnrs.fr/imp-ss \
#       smbspool x x title 1 x github/nixie-dotses/README.md
#
# Anyhoo, I'm giving up on this for the moment cos it's a bitch to debug!
