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

    if ! grep -q "$BIN_DIR" <<<"$PATH"; then
        echo "export PATH=\$HOME/bin:\$PATH" >>~/"$shell_rc"
        source ~/"$shell_rc"
    fi

    log "Script has been installed successfully. You can run the toolkit using 'php_refactor_toolkit'."
    log "Running the toolkit now..."
    $SCRIPT_PATH
}

install
