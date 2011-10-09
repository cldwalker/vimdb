Description
===========

Search your vim keybindings precisely by keystroke, mode, description or where they came from.
Creates a keys database, ~/.keys.marshal, from index.txt (default keys) and :map (for user + plugin
keys). Tested with vim >= 7.2 on a mac.

Usage
=====

    # List keys with Ctrl
    $ keys list C-

    # List keys with Ctrl-A combo
    $ keys list C-A

    # List keys with Esc key
    $ keys list E-

    # List keys with Leader
    $ keys list L-

    # List insert mode keys
    $ keys list -m=i

    # List keys I've defined in vimrc
    $ keys list user -f=from

    # Plugins are assumed to be in ~/.vim/plugins/ directory, change with --plugins-dir
    # List keys from my plugins
    $ keys list plugin -f=from

    # List keys from snipmate plugin
    $ keys list snipmate -f=from

    # List keys that contain completion in description
    $ keys list completion -f=desc

    # For more
    $ keys help list

Modes
=====

Vim modes are represented as single letters

* n: normal
* c: commandline
* i: insert
* o: operation
* v: visual
* s: select

If you're unfamiliar with all these modes read about them in vim with ':h :map-modes'.

The following modes from :map were altered to fit into the above modes:

* ! -> ci
* l -> ci
* x -> v
* v -> vs

Todo
====

* Tests!
* Fix index.txt edge cases
* Either add support for other apps (zsh) or add more vim search tools
* Commands for keys analytics
