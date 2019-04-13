# jyh dotfiles

My home directory configuration files for unix and unix-like systems. 

full emacs and zsh files are in git submodules.

## Installation

(requires [stow](https://gnu.org/software/stow))

```
> source stow.sh
```

or, to selectively install all dotfiles under a given directory, do

```
> stow vim  # install only vim-related dotfiles
> stow git  # install only git-related dotfiles
# etc...
```
