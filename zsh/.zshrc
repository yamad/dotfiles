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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$( pyenv init - )"	    # python version manager
eval "$( pyenv virtualenv-init - )" # python virtualenv
eval "$( rbenv init - )"	    # ruby version manager
eval "$( nodenv init - )"	    # node.js version manager
source ~/perl5/perlbrew/etc/bashrc  # perl version manager

# keychain for ssh keys
keychain --nogui -Q ~/.ssh/id_rsa ~/.ssh/jyh
source ~/.keychain/$HOST-sh > /dev/null

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi
