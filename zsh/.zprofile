# set ~/.profile env vars in zsh
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
# keychain for ssh keys
eval `keychain --eval --agents ssh id_rsa`
