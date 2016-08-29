
dotfiles
===================

My .dotfiles.

## Installation

Clone this repo (or your own fork!) to your **home** directory (`/Users/username`).
```
$ cd ~
$ git clone https://github.com/mscoutermarsh/dotfiles
```

Install rcm

```
$ brew tap thoughtbot/formulae
$ brew install rcm
```

Run rcm (this command expects that you cloned your dotfiles to `~/dotfiles/`)
```
$ env RCRC=$HOME/dotfiles/rcrc rcup
```
RCM creates dotfile symlinks (`.vimrc` -> `/dotfiles/vimrc`) from your home directory to your `/dotfiles/` directory.

### Installing Vim Plugins

Plugins are listed in `vimrc.bundles`.

To install them you'll need vundle. Installation directions are here: https://github.com/gmarik/Vundle.vim.
Once vundle is installed. Open vim (`$ vim`) and type `:PluginInstall`. And then restart vim. You'll need to do this for all the plugins to work.

# Installing Tmux Plugins

Plugins are listed in `tmux.conf`.

To install them you will need tpm. Installation directions are here: https://github.com/tmux-plugins/tpm.
Once tpm is installed, open tmux and press `prefix + I`.

### Installing Tmux Plugins

Plugins are listed in tmux.conf.

To install them you will need tpm. Installation directions are here:
https://github.com/tmux-plugins/tpmu

### Git Config
Make sure you update ```gitconfig``` with your own name and email address. Otherwise you'll be committing as me. :smile_cat:

**Tmux**
```
$ brew install tmux
$ brew install reattach-to-user-namespace
```

---
These are a heavily modified version of Thoughtbot's dotfiles. More detailed instructions are available here: http://github.com/thoughtbot/dotfiles.
