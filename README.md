Description
===========

Increase the speed and amount of vim knowledge at your fingertips with precise
searching of vim's items: keys (keybindings), options and commands.
[vimdb](http://github.com/cldwalker/vimdb) is aware of vim's default items, ones
in your vimrc and ones in plugins. vimdb's plugin detection works only if you're
using a pathogen-like setup i.e. each plugin has its own directory under
~/.vim/bundle/ (see Configuration below to change the directory). Tested with
vim >= 7.2 on mac and windows. Works only on ruby 1.9.x.

Install
=======

    $ gem install vimdb

Usage
=====

Basic examples searching different vim items:

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
    262 rows in set


    # List options that contain word 'window' in any field
    $ vimdb options window -a
    +----------------+--------+----------------------------------------------------+
    | name           | alias  | desc                                               |
    +----------------+--------+----------------------------------------------------+
    | autochdir      | acd    | change directory to the file in the current window |
    | bufhidden      | bh     | what to do when buffer is no longer in window      |
    | cedit          |        | key used to open the command-line window           |
    | cmdwinheight   | cwh    | height of the command-line window                  |
    | cscopequickfix | csqf   | use quickfix window for cscope results             |
    | cursorbind     | crb    | move cursor in window as it moves in other windows |
    | diff           |        | use diff mode for the current window               |
    | equalalways    | ea     | windows are automatically made the same size       |
    | guiheadroom    | ghr    | GUI: pixels room for window decorations            |
    | helpheight     | hh     | minimum height of a new help window                |
    | icon           |        | let Vim set the text of the window icon            |
    ...
    30 rows in set

    # Search for commands from pathogen plugin
    $ vimdb commands pathogen -f=from
    +----------+-------+---------------------+-----------------------------------------------------+
    | name     | alias | from                | desc                                                |
    +----------+-------+---------------------+-----------------------------------------------------+
    | Helptags |       | pathogen.vim plugin | :call pathogen#helptags()                           |
    | Ve       |       | pathogen.vim plugin | :execute s:find(<count>,'edit<bang>',<q-args>,0)    |
    | Vedit    |       | pathogen.vim plugin | :execute s:find(<count>,'edit<bang>',<q-args>,0)    |
    | Vopen    |       | pathogen.vim plugin | :execute s:find(<count>,'edit<bang>',<q-args>,1)    |
    | Vpedit   |       | pathogen.vim plugin | :execute s:find(<count>,'pedit',<q-args>,<bang>1)   |
    | Vread    |       | pathogen.vim plugin | :execute s:find(<count>,'read',<q-args>,<bang>1)    |
    | Vsplit   |       | pathogen.vim plugin | :execute s:find(<count>,'split',<q-args>,<bang>1)   |
    | Vtabedit |       | pathogen.vim plugin | :execute s:find(<count>,'tabedit',<q-args>,<bang>1) |
    | Vvsplit  |       | pathogen.vim plugin | :execute s:find(<count>,'vsplit',<q-args>,<bang>1)  |
    +----------+-------+---------------------+-----------------------------------------------------+
    9 rows in set

    # Info about how a vim item is made
    $ vimdb info keys
    Created using index.txt and :map

    # For a list of all commands
    $ vimdb

## More Usage

As you can see from the last example, vimdb supports options for each command.
For a command's listing of options use --help or -h:

    $ vimdb keys --help
    Usage: vimdb keys [QUERY]

    Options:
      -a, --all          search all fields
      -f, --field        field to query
      -i, --ignore_case
      -m, --mode         search by mode, multiple modes are ORed
      -n, --not          return non-matching results
      -r, --regexp       query is a regexp
      -R, --reload       reloads items
      --reverse_sort
      -s, --sort         sort by field
      -t, --tab          print tab-delimited table

    Description:
      List vim keys


As you can see, keys can be searched by keystroke, mode, description or from
(default, user or plugin name). Some examples:

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

    # List keys from my plugins
    $ vimdb keys plugin -f=from

    # List keys from snipmate plugin
    $ vimdb keys snipmate -f=from

    # List keys that contain completion in description
    $ vimdb keys completion -f=desc

Advanced Usage
==============

vimdb can be customized with your own commands thanks to its rc file and command
engine, [boson](http://github.com/cldwalker/boson). For example,
[my rc file](https://github.com/cldwalker/dotfiles/blob/master/.vimdbrc)
defines a command that detects conflicts between default keys and plugin keys:

    $ vimdb conflict
    +-------+------+---------------------+---------------------------------------------------------------------------------+
    | key   | mode | from                | desc/action                                                                     |
    +-------+------+---------------------+---------------------------------------------------------------------------------+
    | C-w o | n    | default             | close all but current window (like |:only|)                                     |
    | C-w o | n    | zoomwin plugin      | <Plug>ZoomWin                                                                   |
    | *     | n    | default             | search forward for the Nth occurrence of the ident under the cursor             |
    | *     | nos  | tcomment_vim plugin | :TCommentRight<CR>                                                              |
    | *     | n    | default             | search forward for the Nth occurrence of the ident under the cursor             |
    | *     | nos  | tcomment_vim plugin | :TComment<CR>                                                                   |
    ...

If you look at conflict's implementation, you see it's only about a dozen lines.
Since vimdb stores vim items as array of hashes, you can use these within
commands for whatever purpose.

To illustrate creating a command, let's create one that lists the first
given number of vim commands. In your ~/.vimdbrc:

```ruby
class Vimdb::Runner
  desc "Prints first X options"
  def first(num)
    # Set item type we're retrieving
    Vimdb.item('options')
    puts Vimdb.user.items.first(num.to_i).map {|e| e[:name] }
  end
end
```

To test drive it:

    $ vimdb first 5
    aleph
    allowrevins
    altkeymap
    ambiwidth
    antialias

Configuration
=============

Configure vimdb with a ~/.vimdbrc (in ruby), which is loaded before every
command request. For example, to configure where plugins are stored:

    # plugins stored in ~/.vim/plugins
    Vimdb.plugins_dir = 'plugins'

For a more thorough example,
[see my rc file](https://github.com/cldwalker/dotfiles/blob/master/.vimdbrc).

Vim Mappings
============

Since vimdb runs on ruby 1.9.x, there's a good chance you don't have vim
compiled against ruby 1.9.x.  No worries, use rvm or rbenv to install a 1.9.x
version. Then to invoke vimdb within vim, set up a key to pipe out to vimdb
using rvm or rbenv:

```vim
map <Leader>v :!rbenv exec vimdb
" or for rvm
map <Leader>v :!rvm 1.9.3 vimdb
```

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

How It Works
============

This gem creates a vimdb database, ~/.vimdb.pstore, by parsing your vim
documentation and outputs of vim commands. When an item is first searched it is
parsed. Subsequent searches are cached. To reload (and reparse) you database,
pass a --reload option to most commands.

Motivation
==========

Wanted to learn faster than :help would let me.

Credits
=======

* mattn for windows support

Contributing
============
[See here](http://tagaholic.me/contributing.html)

Todo
====

* Add support for more vim items - variables, functions
* Considering user annotation for vim items
