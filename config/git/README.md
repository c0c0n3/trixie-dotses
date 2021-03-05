Git Configuration Files
=======================
Some basic `git` configuration I use everywhere. Copy the files in your
home dir.

#### GitHub Access
[Starting from Aug 2021][gh-sec-notice], you won't be able to access
GitHub repos from the `git` CLI using a password anymore. You need to
[use a personal access token][gh-access-token] as a password. Note the
GitHub guide for MacOS tells you to use OSX Key Chain as credential
helper

    $ git config --global credential.helper osxkeychain

but the `cache` helper in `.gitconfig` seems to work too, perhaps
it piggybacks on OSX Key Chain?




[gh-access-token]: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
[gh-sec-notice]: https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/
