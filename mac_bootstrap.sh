#!/bin/zsh -eu

# Ensure script operates in the same env as a login shell (optional, consider if truly needed)
# source ~/.zshrc
# source ~/.profile

NEXUS_URL="https://sonatype-nexus.ops.gcp.tempus.cloud"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH immediately for current script execution
    export PATH="/opt/homebrew/bin:$PATH" # For Apple Silicon Macs
    export PATH="/usr/local/bin:$PATH"   # For Intel Macs (if applicable)

    echo "Creating Brewfile..."
    cat <<EOF > Brewfile
tap "d12frosted/emacs-plus"
brew "azure-cli"
brew "emacs-plus"
brew "gcc"
brew "git"
brew "jq"
brew "samtools"
brew "stow"
brew "ripgrep"
brew "tmux"
brew "zsh"
cask "dash"
cask "datagrip"
cask "iterm2"
cask "rectangle-pro"
cask "spotify"
cask "visual-studio-code"
EOF

    echo "Running brew bundle..."
    brew bundle
else
    echo "Homebrew already installed."
fi

echo "Checking for uv..."
if ! command -v uv &> /dev/null; then
    echo "uv not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    echo "Configuring uv..."
    mkdir -p "$XDG_CONFIG_HOME/uv"
    cat <<EOF > "$XDG_CONFIG_HOME/uv/uv.toml"
[[index]]
url = "${NEXUS_URL}/repository/pypi/simple"

[pip]
index-url = "${NEXUS_URL}/repository/pypi/simple"
EOF

    export PATH="${HOME}/.local/bin:$PATH"
    uv python install 3.13
else
    echo "uv already installed."
fi

echo "Setting up pip configuration..."
python3 -m pip config --user set global.extra-index-url "${NEXUS_URL}/repository/pypi/simple"
python3 -m pip config --user set global.timeout 10
python3 -m pip config --user set global.require-virtualenv True

echo "Checking for gcloud CLI..."
if ! command -v gcloud &> /dev/null; then
    echo "gcloud CLI not found. Installing Google Cloud CLI..."
    GCLOUD_TAR="google-cloud-cli-darwin-arm.tar.gz"
    # Use curl instead of wget as wget might not be installed
    curl -o "${GCLOUD_TAR}" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TAR}"
    tar -xzf "${GCLOUD_TAR}" -C $HOME/.local/google-cloud-sdk # This extracts to 'google-cloud-sdk'
    $HOME/.local/google-cloud-sdk/install.sh --quiet --path-update true --usage-reporting false --rc-path "$HOME/.zshrc"
    rm "${GCLOUD_TAR}" # Clean up the tarball
    echo "Google Cloud CLI installed. Please restart your shell or source ~/.zshrc for gcloud to be in your PATH."
else
    echo "gcloud CLI already installed."
fi

echo "Checking for SDKMAN!..."
if ! command -v sdk &> /dev/null; then
    echo "SDKMAN! not found. Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash

    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    echo "Installing Java with SDKMAN!..."
    sdk install java 21.0.7-tem
else
    echo "SDKMAN! already installed."
fi

echo "Checking for Nextflow..."
if ! command -v nextflow &> /dev/null; then
    echo "Nextflow not found. Installing Nextflow..."
    curl -s https://get.nextflow.io | bash
    chmod +x nextflow
    mkdir -p "$HOME/.local/bin"
    mv nextflow "$HOME/.local/bin"
    echo "Nextflow installed to $HOME/.local/bin. Ensure this directory is in your PATH."
else
    echo "Nextflow already installed."
fi

echo "Script complete!"
