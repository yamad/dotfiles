alias ls='ls --color=always' # colorize ls
alias ap='cat >> ~/.reminders'
alias e='emacsclient -nw'
alias lpduplex='lp -o sides=two-sided-long-edge'
alias pipiu="pip install --install-option='--user'"
alias pipiu2="pip2 install --install-option='--user'"
alias ziplist="zipinfo -1"
alias inkscapeFix='wmctrl -r Inkscape -e 0,2560,1600,1920,1080'
alias scribus_fix='ps2pdf -dCompressFonts=true -dPDFSETTINGS=/prepress -dEmbedAllFonts'
alias spacemacs='HOME=~/.spacemacs emacs'
alias rtags-capture="intercept-build"
if type nvim > /dev/null 2>&1; then
    alias vim='nvim'
fi

# pun more common terminal over ssh
if [[ "$TERM" == "st-256color" ]]; then
    alias ssh="TERM=xterm-256color ssh"
fi
