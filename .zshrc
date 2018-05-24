PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi 

zmodload zsh/zprof  # profiling 

source ~/.profile

# Uncomment following line if you want red dots to be displayed while waiting for completion COMPLETION_WAITING_DOTS="true"

# function path for zsh
fpath=( ~/.zsh/lib $fpath )

autoload -U compinit
compinit -i

autoload -Uz vcs_info
autoload -U git_prompt_info
autoload -U zmv

bindkey -e # emacs bindings

# nvm setup
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

source ~/.dir_colors

source ~/.zsh/lib/git.zsh

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-nvm/zsh-nvm.plugin.zsh
#source ~/.zsh/plugins/git.plugin.zsh
source ~/.zsh/jyh.zsh-theme

source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

source ~/perl5/perlbrew/etc/bashrc

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi

source ~/.zprofile

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source ~/.nix-profile/etc/profile.d/nix.sh
