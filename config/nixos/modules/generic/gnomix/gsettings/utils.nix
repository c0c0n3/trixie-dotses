#
# Utils for the various gsettings modules.
#
with import <nixpkgs> {};
with lib;
rec {

  # gsettings command to set a value.
  set = "${pkgs.glib.dev}/bin/gsettings set";

  # returns a set command only if v is not null, otherwise the empty string.
  # k is the GSettings schema and key of the value to set.
  # v can be a list too.
  # e.g. (outer quotes and gsettings path omitted from RHS to improve
  # legibility)
  #     setIf null   "some.schema key"  ===>
  #     setIf "hi"   "some.schema key"  ===> gsettings set some.schema key 'hi'
  #     setIf ""     "some.schema key"  ===> gsettings set some.schema key ''
  #     setIf [1 2]  "s k"              ===> gsettings set s k "['1', '2']"
  #     setIf []     "s k"              ===> gsettings set s k "[]"
  setIf = v : k :
    if v == null then ""
    else
      if isList v then "${set} ${k} ${lst v}"
      else "${set} ${k} ${val v}";

  # converts a boolean to it string rep.
  toBool = b : if b then "true" else "false";

  # converts a value to a quoted string you can use as a gsettings value.
  # takes booleans into account but does *no* escaping.
  # e.g.
  #     val ./..  ===>  '/some/path'
  #     val true  ===>  'true'
  #     val "hi"  ===>  'hi'
  val = v : "'${if isBool v then toBool v else toString v}'";

  # converts a list of values to a quoted list you can use as a gsettings
  # value using the val function.
  # e.g.
  #     lst ["<s><h>1"]       ===>  "['<s><h>1']"
  #     lst ["<s><h>1" true]  ===>  "['<s><h>1', 'true']"
  lst = vs : ''"['' + (concatMapStringsSep ", " val vs) + '']"'';

  # outputs a gsettings script fragment by mapping setIf on the input set.
  # - header: the fragment header e.g. "Look & Feel"
  # - kvSet: a set where each name is a GSettings schema/key and the
  #   corresponding value is the value to set from our config. Null
  #   values will be skipped.
  # e.g.
  #     setIfFragment "header" {
  #       "some.schema key" = null;
  #       "s k" = [1 2];
  #       "x y" = "";
  #     };
  # results in
  #           # header
  #           gsettings set s k "['1', '2']"
  #           gsettings set x y ''
  #
  setIfFragment = header : kvSet :
  let
    cmds = filter (x : x != "")
                  (mapAttrsToList (n : v : setIf v n) kvSet);
    lines = [ "# ${header}" ] ++ cmds;
  in
    concatStringsSep "\n" lines;

}
