#
# Apple Script to grab the item currently selected in Finder.
# Run from the command line with
#
# $ osascript finder-selection.scpt
#
tell application "Finder"
    set sel to selection
    if sel is not {} then
        set hfsPath to item 1 of sel as text
        set posixPath to (the POSIX path of hfsPath)
        return posixPath
    else
        return {}
    end if
end tell
