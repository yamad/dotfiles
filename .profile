export LANG=en_US.UTF-8
export PATH="$HOME/bin:$HOME/.local/bin:usr/local/sbin:$HOME/.cabal/bin:$PATH:$HOME/.rvm/bin:$HOME/src/algs4/bin"
export INFOPATH="$HOME/info:"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export EDITOR="emacsclient -a 'vim' -t"
export HOMEBREW_CURL=$HOME/.nix-profile/bin/curl
export CURL_CA_BUNDLE="$HOME/.nix-profile/etc/ssl/certs/ca-bundle.crt"
source ~/.nix-profile/etc/profile.d/nix.sh
export NIX_PATH=$NIX_PATH:jyhpkgs=$HOME/src/vendor/nixpkgs
