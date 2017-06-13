PROFILE_STARTUP=true
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

zmodload zsh/zprof  # profiling

# Path to your oh-my-zsh configuration.
#ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="jyh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
#CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# function path for zsh
#fpath=( ~/.zsh/lib $fpath )

#autoload -U compinit
#compinit -i

#autoload -Uz vcs_info
#autoload -U git_prompt_info
#autoload -U zmv
#source $ZSH/oh-my-zsh.sh

# nvm setup
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

source ~/.zsh/lib/git.zsh

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source ~/.zsh/plugins/zsh-nvm/zsh-nvm.plugin.zsh
source ~/.zsh/plugins/git.plugin.zsh
source ~/.zsh/jyh.zsh-theme


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# lazy-load wrapper
function pyenv() {
    eval "$( command pyenv init - )"
    pyenv "$@"
}

# keychain for ssh keys
keychain --nogui -Q ~/.ssh/id_rsa ~/.ssh/jyh
source ~/.keychain/$HOST-sh > /dev/null


if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi
