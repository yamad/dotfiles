#export LANG=en_US.UTF-8
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cabal/bin:$PATH"
export INFOPATH="$HOME/info:"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export EDITOR="emacsclient -a 'vim' -t"

# TeXLive
export PATH="$PATH:/usr/local/texlive/current/bin/x86_64-linux"
export INFOPATH="$INFOPATH:/usr/local/texlive/current/texmf-dist/doc/info"
export MANPATH="$MANPATH:/usr/local/texlive/current/texmf-dist/doc/man"

# python version manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export ANDROID_HOME="$HOME"/.android-sdk
export PATH="$ANDROID_HOME"/tools/bin:"$ANDROID_HOME"/platform-tools:$PATH
#export JAVA_OPTS="-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee"

# node version manager
export NVM_DIR="$HOME/.nvm"

# sdkman (java) install manager
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh

setxkbmap -option ctrl:nocaps

export PATH="$HOME/.cargo/bin:$PATH"

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
