Description
===========

Search your vim keybindings precisely by keystroke, mode, description or where they came from.
Creates a vimdb database, ~/.vimdb.pstore, from index.txt (default keys) and :map (for user + plugin
keys). Tested with vim >= 7.2 on a mac.

Usage
=====

    # List keys with Ctrl
    $ vimdb list C-

    # List keys with Ctrl-A combo
    $ vimdb list C-A

    # List keys with Esc key
    $ vimdb list E-

    # List keys with Leader
    $ vimdb list L-

    # List insert mode keys
    $ vimdb list -m=i

    # List keys I've defined in vimrc
    $ vimdb list user -f=from

    # Plugins are assumed to be in ~/.vim/plugins/ directory, change with --plugins-dir
    # List keys from my plugins
    $ vimdb list plugin -f=from

    # List keys from snipmate plugin
    $ vimdb list snipmate -f=from

    # List keys that contain completion in description
    $ vimdb list completion -f=desc

    # For more
    $ vimdb help list

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
* Add support for more vim items - commands, variables, functions
* Fix keys - index.txt edge cases
