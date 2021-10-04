# Snippets for installing a good environment in Ubuntu 18.04

# Usage::
#
#   source ubuntu_setup.sh
#   # select and call desired setup/install functions, e.g:
#   install-essentials
#   install-*
#
#
# Testing
# -------
#
# This script is tested using Hashicorp Vagrant and Vagrantfile is provided for this purpose::
#
#   vagrant up
#   vagrant ssh
#   source /vagrant/ubuntu_setup.sh
#   install-*
#

# return the (guessed) rc config for the current shell
_shellrc() {
    case ${SHELL##*/} in
        bash)
            echo "$HOME/.bashrc"
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        *)
            echo "Warning: supported shells are bash/zsh" >&2
            echo ""
            ;;
    esac
}


# run apt-get update only every 5 minutes
apt-ensure-recent-update() {
    UPDATE_INTERVAL_SECS=$((5*60))
    apt_epoch=$(date -d "$(stat -c %y /var/lib/apt/periodic/update-success-stamp)" +%s)
    now_epoch=$(date +%s)
    seconds_since_update=$(( $now_epoch - $apt_epoch ))
    if (( $UPDATE_INTERVAL_SECS < $seconds_since_update )); then
        sudo apt-get update
    fi
}


install-essentials() {
    apt-ensure-recent-update
    sudo apt-get install -y git stow zsh
}


install-git() {
    apt-ensure-recent-update
    sudo apt-get install -y git-lfs
    git-lfs install
}


install-xmonad() {
    apt-ensure-recent-update
    sudo apt-get install -y --no-install-recommends \
         xmonad dzen2 \
         conky gnome-session-fallback ghc \
         libghc-xmonad-contrib-dev dmenu
}

# fix sleep bug in 18.04. switch s2idle to deep default
# otherwise, battery dies even when lid is closed
install-mem-sleep() {
    apt-ensure-recent-update
    sudo apt-get install -y s2idle
    sudo /bin/bash -c "echo 'power/mem_sleep = deep' > /etc/sysfs.d/mem_sleep.conf"
    # then restart
}


install-pyenv() {
    apt-ensure-recent-update
    sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    if [[ ! -d ~/.pyenv ]]
    then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $(_shellrc)
        echo 'export PATH="$PYENV_ROOT/bin${PATH:+:$PATH}"' >> $(_shellrc)
        cat <<EOF >> $(_shellrc)

if command -v pyenv 1>/dev/null 2>&1; then
    eval "\$(pyenv init -)"
fi
EOF
    fi

    pyenv_plugins=(pyenv-doctor pyenv-update pyenv-which-ext pyenv-pip-migrate)
    for plugin in ${pyenv_plugins[@]}; do
        [[ ! -d ~/.pyenv/plugins/${plugin} ]] && git clone https://github.com/pyenv/${plugin}.git ~/.pyenv/plugins/${plugin}
    done

    # source pyenv installation for the current shell
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin${PATH:+:$PATH}"
    pyenv update
}


_latest_pyenv_version() {
    local query=$1
    [[ -z $query ]] && query=$DEFAULT_QUERY
    pyenv install --list \
        | grep -vE "(^Available versions:|-src|dev|rc|alpha|beta|(a|b)[0-9]+)" \
        | grep -E "^\s*$query" \
        | sed 's/^\s\+//' \
        | tail -1
}


install-pipx() {
    if ! command -v pyenv 1>/dev/null 2>&1; then
        install-pyenv
        pyenv install $(_latest_pyenv_version 3)
    fi

    local pyenv_prefix=$(pyenv prefix $(_latest_pyenv_version 3))
    ${pyenv_prefix}/bin/python -m pip install --user pipx
    ${pyenv_prefix}/bin/python -m userpath append ~/.local/bin

    # source pipx for current shell
    export PATH="~/.local/bin:$PATH"
}


install-pipx-utilities() {
    if ! command -v pipx 1>/dev/null 2>&1; then
        install-pipx
    fi

    pipx install httpie
    pipx install tox
    pipx install black
    pipx install pre-commit
    pipx install cookiecutter
    pipx install invoke
    pipx install tmuxp
}


install-rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}


install-rust-utilities() {
    if ! command -v nix-env 1>/dev/null 2>&1; then
        install-nix
        source $(_shellrc)
    fi

    # fd       - find replacement
    # exa      - ls replacement
    # ripgrep  - ack/ag replacement
    # bat      - cat replacement
    # procs    - ps replacement
    # tealdeer - tldr man pages
    # broot    - file explorer
    nix-env -i fd exa ripgrep bat procs tealdeer broot
}


install-asdf() {
    if ! command -v git 1>/dev/null 2>&1; then
        install-git
    fi

    [[ -d ~/.asdf ]] && return

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    (cd ~/.asdf
    git checkout "$(git describe --abbrev=0 --tags)")

    echo ". $HOME/.asdf/asdf.sh" >> $(_shellrc)
}


install-fzf() {
    [[ -d ~/.fzf ]] && return

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}


install-vagrant() {
    vagrant_version=2.2.9
    vagrant_url_root=https://releases.hashicorp.com/vagrant/${vagrant_version}
    curl -Os ${vagrant_url_root}/vagrant_${vagrant_version}_x86_64.deb
    sudo dpkg -i vagrant_${vagrant_version}_x86_64.deb
    rm vagrant_${vagrant_version}_x86_64.deb
}


install-virtualbox() {
    VIRTUALBOX_KEYID=(B9F8D658297AF3EFC18D5CDFA2F683C52980AECF
                      7B0FAB3A13B907435925D9C954422A4B98AB5139)
    sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "${VIRTUALBOX_KEYID[@]}"
    sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
    sudo apt-get update
    sudo apt-get install -y virtualbox-6.0
}


install-ansible() {
    apt-ensure-recent-update
    sudo apt-get install -y software-properties-common

    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
}


install-docker() {
    DOCKER_KEYID=9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "$DOCKER_KEYID"
    sudo apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    sudo usermod -aG docker $USER

    pipx install docker-compose
}


install-editors() {
    apt-ensure-recent-update
    sudo snap install pycharm-professional --classic # pycharm
    sudo snap install code --classic                 # visual studio code
    sudo apt-get install -y vim
    sudo snap install intellij-idea-community --classic # intellij
}


install-useful-tools() {
    useful_tools=(tmux tree zeal cmake clang direnv htop kcachegrind mosh openssh-server stow unzip valgrind wget curl zip silversearcher-ag vim keychain gnome-tweak-tool bash-completion x11vnc)
    sudo apt-get install -y "${useful_tools[@]}"

    install-pipx-utilities
    install-rust-utilities
    install-fzf
    install-asdf
}


install-slack() {
    sudo snap install slack --classic
}


install-spotify() {
    sudo snap install spotify
}


install-sdkman() {
    curl -s https://get.sdkman.io | $SHELL
}


install-android-support() {
    sdk install java 8.0.212-zulu
    sdk use java 8.0.212-zulu
    ANDROID_SDK_TOOLS_VERSION=4333796
    ANDROID_HOME="$HOME"/.android-sdk
    export ANDROID_HOME
    ANDROID_SDK_TOOLS_ZIP=sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip
    curl -LO https://dl.google.com/android/repository/${ANDROID_SDK_TOOLS_ZIP}
    mkdir -p "$ANDROID_HOME"
    unzip "$ANDROID_SDK_TOOLS_ZIP" -d "$ANDROID_HOME"

    export PATH="$ANDROID_HOME"/tools/bin:"$ANDROID_HOME"/platform-tools${PATH:+:${PATH}}

    sdkmanager "platform-tools" "platform;android-29" "build-tools;29.0.0"
}


install-nix() {
    curl -L https://nixos.org/nix/install | sh
    # source nix installation for the current shell
    . $HOME/.nix-profile/etc/profile.d/nix.sh
}


install-st() {
    mkdir -p $HOME/src/vendor && cd $HOME/src/vendor
    git clone https://git.suckless.org/st
    cd st
}


install-emacs() {
    EMACS_VERSION=26.2
    git clone https://github.com/emacs-mirror/emacs $HOME/src/vendor/emacs
    cd $HOME/src/vendor/emacs
    git checkout emacs-$EMACS_VERSION
    sudo apt-get install -y autoconf texinfo libgif-dev libgtk-3-dev libjpeg9-dev libtiff-dev libxpm-dev
    ./autogen.sh
    mkdir -p build-$EMACS_VERSION && cd build-$EMACS_VERSION
    ../configure
    make
    sudo make install prefix=/usr/local/stow/emacs-$EMACS_VERSION
    cd /usr/local/stow
    sudo stow emacs-$EMACS_VERSION
}


install-dropbox() {
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
    sudo apt-add-repository "deb [arch=amd64] https://linux.dropbox.com/ubuntu $(lsb_release -cs) main"
    sudo apt-get update
    sudo apt-get install -y dropbox
}


install-zsh() {
    apt-ensure-recent-update
    sudo apt-get install -y zsh
    chsh -s /usr/bin/zsh

    # prompt
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
}


install-conda() {
    MINICONDA_LATEST=Miniconda3-latest-Linux-x86_64.sh
    curl -LO https://repo.anaconda.com/miniconda/${MINICONDA_LATEST}
    bash ${MINICONDA_LATEST}
}


install-qemu() {
    apt-ensure-recent-update
    sudo apt-get install -y qemu-user-static qemu-system \
         gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
}


install-bazel() {
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    sudo apt-get update
    sudo apt-get install -y bazel
    sudo apt-get install -y g++ unzip zip
}


install-microsoft-teams() {
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'

    sudo apt-get update
    sudo apt-get install -y teams
}


install-bitbucket-ssh-key() {
    ssh-keygen

    cat <<EOF

WARNING: MANUAL STEPS

Setup Bitbucket SSH Key
-----------------------

  1. Go to bitbucket.org and login
  2. Go to *Personal Settings* from avatar in lower left
  3. Select *SSH Keys*
  4. Copy the text below and enter it as new SSH key:

EOF

    cat ~/.ssh/id_rsa.pub

    cat <<EOF

Reference: https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/#SetupanSSHkey-ssh2
EOF
}


install-python-dev() {
    install-pyenv

    pyenv install $(_latest_pyenv_version 3)
    pyenv install $(_latest_pyenv_version 3.6)
    pyenv global $(_latest_pyenv_version 3)

    install-pipx
    install-docker
}


install-new-machine-setup() {
    install-essentials
    install-git
    install-useful-tools

    install-mem-sleep

    install-virtualbox
    install-vagrant

    install-python-dev
    install-pipx-utilities
    install-rust-utilities
    sudo snap install code --classic

    install-microsoft-teams
}


install-new-machine-setup-user-steps() {
    install-bitbucket-ssh-key
}
