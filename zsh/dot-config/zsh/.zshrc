# Enable Powerlevel10k instant prompt. Should stay close to the top of $ZDOTDIRrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

zmodload zsh/zprof  # profiling

# function path for zsh
fpath+=(
    $ZDOTDIR/lib
    $ZDOTDIR/completions
)

autoload -U compinit
compinit -i

autoload -Uz vcs_info
autoload -U git_prompt_info
autoload -U zmv

bindkey -e # emacs bindings

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$ZDOTDIR/.zsh_history"
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

# python version manager
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$( pyenv init - )"
fi

# keychain for ssh keys
if command -v keychain &> /dev/null; then
    eval `keychain --eval --agents ssh id_rsa`
    source ~/.keychain/$HOST-sh > /dev/null
fi

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi
