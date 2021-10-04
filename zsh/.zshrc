# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
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

. $HOME/.asdf/asdf.sh

# function path for zsh
fpath=( ~/.zsh/lib $fpath )
fpath=( ~/.zsh/completions $fpath )
fpath=( ${ASDF_DIR}/completions $fpath )

autoload -U compinit
compinit -i

autoload -Uz vcs_info
autoload -U git_prompt_info
autoload -U zmv

bindkey -e # emacs bindings

source ~/.zsh/lib/git.zsh
#source ~/.zsh/jyh.zsh-theme
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/git.plugin.zsh

source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

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

# python version manager
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$( pyenv init - )"
fi

# keychain for ssh keys
eval `keychain --eval --agents ssh id_rsa`
source ~/.keychain/$HOST-sh > /dev/null

eval "$(direnv hook zsh)"

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    # restore stderr to the value saved in FD 3
    exec 2>&3 3>&-
fi

# opam configuration
test -r /home/jyh/.opam/opam-init/init.zsh && . /home/jyh/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

source /home/jyh/.config/broot/launcher/bash/br

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/p10k.zsh ]] || source ~/.zsh/p10k.zsh

[ -z "usr/bin/aws_completer" ] && complete -C '/usr/bin/aws_completer' aws




autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
