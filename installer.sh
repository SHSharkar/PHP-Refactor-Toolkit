#!/bin/bash

REPO_URL="https://github.com/SHSharkar/PHP-Refactor-Toolkit"
INSTALLER_DIR="$HOME/php_refactor_toolkit"
BIN_DIR="$HOME/bin"
SCRIPT_NAME="php_refactor_toolkit.sh"
SCRIPT_PATH="$BIN_DIR/php_refactor_toolkit"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - ${BOLD}$1${NC}"
}

install() {
    if [ -d "$INSTALLER_DIR" ] && [ "$(ls -A $INSTALLER_DIR)" ]; then
        log "${YELLOW}Directory $INSTALLER_DIR already exists and is not empty. Removing it...${NC}"
        rm -rf "$INSTALLER_DIR"
    fi

    log "Cloning repository..."
    git clone "$REPO_URL" "$INSTALLER_DIR"

    log "Copying configuration files..."
    cp "$INSTALLER_DIR/rector.php" "$HOME/rector.php"
    cp "$INSTALLER_DIR/.ecs.php" "$HOME/.ecs.php"
    cp "$INSTALLER_DIR/.php-cs-fixer.php" "$HOME/.php-cs-fixer.php"
    cp "$INSTALLER_DIR/pint.json" "$HOME/pint.json"

    log "Setting up script in bin directory..."
    mkdir -p "$BIN_DIR"
    cp "$INSTALLER_DIR/$SCRIPT_NAME" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"

    read -p "Do you want to use .zshrc or .bashrc? (default is .zshrc): " shell_rc
    shell_rc=${shell_rc:-.zshrc}

    if [ "$shell_rc" == ".zshrc" ]; then
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            log "${RED}Oh My Zsh is not installed. Please install it or choose .bashrc.${NC}"
            return
        fi
    fi

    if ! grep -q "export PATH=\$HOME/bin:\$PATH" ~/"$shell_rc"; then
        echo "export PATH=\$HOME/bin:\$PATH" >>~/"$shell_rc"
        source ~/"$shell_rc"
        log "Added \$HOME/bin to your PATH in ~/$shell_rc"
    else
        log "\$HOME/bin is already in your PATH in ~/$shell_rc"
    fi

    log "Script has been installed successfully."
    log "To run the toolkit, please execute the following command:"
    log "${GREEN}php_refactor_toolkit${NC}"
}

install
