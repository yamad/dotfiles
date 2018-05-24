export LANG=en_US.UTF-8
export PATH="$HOME/bin:$HOME/.local/bin:usr/local/sbin:usr/local/bin:$HOME/.cabal/bin:$PATH"
export INFOPATH="$HOME/info:"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export EDITOR="emacsclient -a 'vim' -t"

# python version manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# node version manager
export NVM_DIR="$HOME/.nvm"
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
