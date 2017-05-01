autoload -U zmv

if [ -n "$DISPLAY" ]; then
    BROWSER=chromium
    export BROWSER
fi

# was incredibly slow
#export NVM_DIR="$HOME/.nvm" && "$(/usr/local/bin/brew --prefix nvm)/nvm.sh"
