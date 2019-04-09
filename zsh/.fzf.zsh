# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jyh/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/jyh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/jyh/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/jyh/.fzf/shell/key-bindings.zsh"
