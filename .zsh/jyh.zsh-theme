# jyh theme
# adjusted from mh theme
# preview: http://cl.ly/1y2x0W0E3t2C0F29043z

# features:
# path is autoshortened to ~30 characters
# displays git status (if applicable in current folder)
# turns username green if superuser, otherwise it is white

# if superuser make the username green
if [[ $UID -eq 0 ]]; then
    NCOLOR="green";
else
    NCOLOR="white";
fi

# prompt
setopt PROMPT_SUBST
USERPR='%F{$NCOLOR}%B%n%b%f'
PATHPR='%F{red}%30<...<%~%<<%f'
SYMBOLPR='%F{gray}%(!.#.$)%f'

if [[ $IN_NIX_SHELL -eq 1 ]]; then
    NIXPR='%F{green}%B|nix%b%f'
else
    NIXPR=''
fi

GITINFO='$(git_prompt_info)'
# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%B"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}%B*%b%f"

# only use fancy prompt in terminals that can handle it
# allows things to work in 'dumb' terminals (like emacs TRAMP) 
case "$TERM" in
stterm*|xterm*|rxvt*|eterm*|screen*)
  PROMPT=${USERPR}${NIXPR}" "${PATHPR}" "${SYMBOLPR}" "
  RPROMPT=${GITINFO}
  ;;
*)
  PROMPT="> "
  RPROMPT=""
  ;;
esac
