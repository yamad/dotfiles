PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

zmodload zsh/zprof  # profiling

# function path for zsh
fpath=( ~/.zsh/lib $fpath )
fpath=( ~/.zsh/completions $fpath )

autoload -U compinit
compinit -i

autoload -Uz vcs_info
autoload -U git_prompt_info
autoload -U zmv
#source $ZSH/oh-my-zsh.sh

bindkey -e # emacs bindings

source ~/.zsh/lib/git.zsh
source ~/.zsh/jyh.zsh-theme
#source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source ~/.zsh/plugins/git.plugin.zsh

source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$( pyenv init - )"	    # python version manager

# keychain for ssh keys
keychain --nogui -Q ~/.ssh/id_rsa ~/.ssh/jyh
source ~/.keychain/$HOST-sh > /dev/null

eval "$(direnv hook zsh)"

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi
