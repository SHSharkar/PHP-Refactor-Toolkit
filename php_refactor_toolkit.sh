#!/bin/bash

# Configuration for various tools
RECTOR_CONFIG="$HOME/rector.php"
ECS_CONFIG="$HOME/.ecs.php"
PHPCS_FIXER_CONFIG="$HOME/.php-cs-fixer.php"
PINT_CONFIG="$HOME/pint.json"
SCRIPT_NAME="php_refactor_toolkit"
BIN_DIR="$HOME/bin"
SCRIPT_PATH="$BIN_DIR/$SCRIPT_NAME"

# Ensure COMPOSER_HOME is set to the correct directory
export COMPOSER_HOME="$HOME/.composer"
COMPOSER_BIN_DIR="$COMPOSER_HOME/vendor/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - ${BOLD}$1${NC}"
}

install_dependency() {
    local package="$1"
    if ! composer global show | grep -q "$package"; then
        log "${YELLOW}$package not found, installing globally...${NC}"
        composer global require "$package"
    else
        log "${GREEN}$package is already installed.${NC}"
    fi
}

install_dependencies() {
    install_dependency "rector/rector"
    install_dependency "symplify/easy-coding-standard"
    install_dependency "friendsofphp/php-cs-fixer"
    install_dependency "laravel/pint"
}

verify_installed() {
    local tool="$1"
    local binary="$COMPOSER_BIN_DIR/$tool"
    if [ ! -f "$binary" ]; then
        log "${RED}$tool not found in $COMPOSER_BIN_DIR. Please ensure it is installed correctly.${NC}"
        return 1
    fi
    return 0
}

refactor_with_tool() {
    local tool="$1"
    local config="$2"
    local file_path="$3"
    local command=""

    log "Refactoring $file_path with $tool..."

    case "$tool" in
    "rector")
        command="$COMPOSER_BIN_DIR/rector process \"$file_path\" --config \"$config\""
        ;;
    "ecs")
        command="$COMPOSER_BIN_DIR/ecs check \"$file_path\" --fix --config \"$config\""
        ;;
    "php-cs-fixer")
        command="$COMPOSER_BIN_DIR/php-cs-fixer fix \"$file_path\" --config=\"$config\""
        ;;
    "pint")
        command="$COMPOSER_BIN_DIR/pint --preset laravel \"$file_path\""
        ;;
    esac

    eval $command 2>&1

    if [ $? -eq 0 ]; then
        log "${GREEN}$file_path has been refactored successfully using $tool.${NC}"
    else
        log "${RED}An error occurred while refactoring $file_path with $tool. Check the detailed error message above.${NC}"
    fi
}

apply_all_tools() {
    local file_path="$1"
    refactor_with_tool "rector" "$RECTOR_CONFIG" "$file_path"
    refactor_with_tool "ecs" "$ECS_CONFIG" "$file_path"
    refactor_with_tool "php-cs-fixer" "$PHPCS_FIXER_CONFIG" "$file_path"
    refactor_with_tool "pint" "$PINT_CONFIG" "$file_path"
}

menu() {
    echo "Select an option:"
    echo "1) Refactor with RectorPHP"
    echo "2) Refactor with Easy Coding Standard"
    echo "3) Refactor with PHP CS Fixer"
    echo "4) Refactor with Laravel Pint"
    echo "5) Apply All"
    echo "6) Quit"
}

setup_global_access() {
    mkdir -p "$BIN_DIR"
    if [ -f "$SCRIPT_PATH" ]; then
        rm -f "$SCRIPT_PATH"
    fi
    cp "$0" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"

    read -p "Do you want to use .zshrc or .bashrc? (default is .zshrc): " shell_rc
    shell_rc=${shell_rc:-.zshrc}

    if ! grep -q "$BIN_DIR" <<<"$PATH"; then
        echo "export PATH=\$HOME/bin:\$PATH" >>~/"$shell_rc"
        source ~/"$shell_rc"
    fi

    log "${GREEN}Script has been copied to ~/bin and made executable globally.${NC}"
    log "${GREEN}You can now run the script from anywhere using '$SCRIPT_NAME'.${NC}"
}

check_global_access() {
    if [[ "$0" != "$SCRIPT_PATH" ]]; then
        log "${YELLOW}The script is not in the global executable location.${NC}"
        read -p "Do you want to set up this script for global access? (y/n): " setup_choice
        setup_choice=$(echo "$setup_choice" | tr '[:upper:]' '[:lower:]')
        case "$setup_choice" in
        y | yes)
            setup_global_access
            log "${GREEN}Please re-run the script using '$SCRIPT_NAME' command.${NC}"
            exit 0
            ;;
        *)
            log "${YELLOW}Global setup skipped. You can still move and make it executable manually later.${NC}"
            ;;
        esac
    else
        log "${GREEN}The script is already in the global executable location.${NC}"
    fi
}

main() {
    check_global_access
    install_dependencies

    while true; do
        menu
        read -p "Enter your choice: " choice
        case "$choice" in
        1)
            tool="rector"
            config="$RECTOR_CONFIG"
            ;;
        2)
            tool="ecs"
            config="$ECS_CONFIG"
            ;;
        3)
            tool="php-cs-fixer"
            config="$PHPCS_FIXER_CONFIG"
            ;;
        4)
            tool="pint"
            config="$PINT_CONFIG"
            ;;
        5) tool="apply_all" ;;
        6)
            log "${YELLOW}Quitting the script. Goodbye!${NC}"
            exit 0
            ;;
        *)
            log "${RED}Invalid option. Please try again.${NC}"
            continue
            ;;
        esac

        if [[ "$tool" != "apply_all" ]]; then
            # Verify if the selected tool is installed
            if ! verify_installed "$tool"; then
                log "${RED}Failed to find the tool: $tool. Please check the installation.${NC}"
                continue
            fi
        fi

        while true; do
            read -p "Enter the full path of the PHP file to refactor (or type 'q' to quit): " file_path
            file_path=$(echo "$file_path" | tr '[:upper:]' '[:lower:]')
            if [[ "$file_path" == "q" ]]; then
                log "${YELLOW}Quitting the script. Goodbye!${NC}"
                break 2
            fi

            if [[ -f "$file_path" && "${file_path##*.}" == "php" ]]; then
                if [[ "$tool" == "apply_all" ]]; then
                    apply_all_tools "$file_path"
                else
                    refactor_with_tool "$tool" "$config" "$file_path"
                fi
            else
                log "${RED}Invalid file path or file is not a PHP file. Please provide a valid PHP file path.${NC}"
            fi

            read -p "Do you want to refactor another file? (N/y): " continue_choice
            continue_choice=$(echo "$continue_choice" | tr '[:upper:]' '[:lower:]')
            continue_choice=${continue_choice:-n}
            if [[ "$continue_choice" != "y" && "$continue_choice" != "yes" ]]; then
                break
            fi
        done
    done
}

main
