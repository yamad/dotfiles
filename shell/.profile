## General .profile file to run for any shell
#
# Shell-specific files should source this file, e.g.
#
# in ~/.zprofile
# [[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export INFOPATH="$HOME/info:"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export EDITOR="emacsclient -a 'vim' -t"

# python version manager
if [[ -s "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# sdkman (java) install manager
if [[ -s "$HOME/.sdkman" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if command -v setxkpmap >& /dev/null; then
    setxkbmap -option ctrl:nocaps
fi

export PATH="$HOME/.cargo/bin:$PATH"

[[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Jason.YamadaHanff/src/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/Jason.YamadaHanff/src/google-cloud-sdk/path.zsh.inc'; fi

