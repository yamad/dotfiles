# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jyh/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/jyh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jyh/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jyh/.fzf/shell/key-bindings.zsh"
