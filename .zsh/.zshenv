autoload -U zmv

if [ -n "$DISPLAY" ]; then
    BROWSER=chromium
    export BROWSER
fi

eval "$(pyenv init -)"
