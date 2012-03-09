Description
===========

Improve your knowledge of vim by precise searching of vim items: keybindings, options and commands.
For example, keys can be searched by keystroke, mode, description or where they came from.  This gem
creates a vimdb database, ~/.vimdb.pstore, from your vim documentation. Tested with vim >= 7.2 on a
mac. Works only on ruby 1.9.x.

Usage
=====

    # List keys with Ctrl
    $ vimdb keys C-
    +---------------+------+---------------------+------------------------------------------
    | key           | mode | from                | desc                                    |
    +---------------+------+---------------------+-----------------------------------------|
    | 0 C-d         | i    | default             | delete all indent in the current line   |
    | <C-End>       | i    | default             | cursor past end of fil                  |
    | <C-End>       | n    | default             | 1  same as "G"                          |
    | <C-Home>      | i    | default             | cursor to start of file                 |
    | <C-Home>      | n    | default             | 1  same as "gg"                         |
    | <C-Left>      | n    | default             | 1  same as "b"                          |
    ...

    # List keys with Ctrl-A combo
    $ vimdb keys C-A

    # List keys with Esc key
    $ vimdb keys E-

    # List keys with Leader
    $ vimdb keys L-

    # List keys with no Leader - not of last search
    $ vimdb keys L- -n

    # List insert mode keys
    $ vimdb keys -m=i

    # List keys I've defined in vimrc
    $ vimdb keys user -f=from

    # Plugins are assumed to be in ~/.vim/bundle/ i.e. for pathogen
    # Change with Vimdb.plugins_dir
    # List keys from my plugins
    $ vimdb keys plugin -f=from

    # List keys from snipmate plugin
    $ vimdb keys snipmate -f=from

    # List keys that contain completion in description
    $ vimdb keys completion -f=desc

    # List options that contain window in description
    $ vimdb options window -f=desc

    # List commands mentioning 'buffer' in any field
    $ vimdb commands buffer -a

    # Info about how vim items were made
    $ vimdb info keys
    $ vimdb info options

    # For more
    $ vimdb help

Configuration
=============

Configure vimdb with a ~/.vimdbrc, which is loaded before every command request. Use it to define
additional commands. For an example, [see my rc
file](https://github.com/cldwalker/dotfiles/blob/master/.vimdbrc).

Key Modes
=========

Vim's key modes are represented as single letters

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

Motivation
==========

Wanted to learn faster than :help would let me.

Contributing
============
[See here](http://tagaholic.me/contributing.html)

Todo
====

* Add support for more vim items - variables, functions
* Considering user annotation for vim items
