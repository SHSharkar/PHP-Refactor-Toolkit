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

log_message() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - ${BOLD}$1${NC}"
}

install_global_dependency() {
    local package="$1"
    if ! composer global show | grep -q "$package"; then
        log_message "${YELLOW}$package not found, installing globally...${NC}"
        composer global require "$package"
    else
        log_message "${GREEN}$package is already installed.${NC}"
    fi
}

ensure_dependencies_installed() {
    install_global_dependency "rector/rector"
    install_global_dependency "symplify/easy-coding-standard"
    install_global_dependency "friendsofphp/php-cs-fixer"
    install_global_dependency "laravel/pint"
}

verify_tool_installed() {
    local tool_name="$1"
    local tool_binary="$COMPOSER_BIN_DIR/$tool_name"
    if [ ! -f "$tool_binary" ]; then
        log_message "${RED}$tool_name not found in $COMPOSER_BIN_DIR. Please ensure it is installed correctly.${NC}"
        return 1
    fi
    return 0
}

run_refactoring_tool() {
    local tool_name="$1"
    local tool_config="$2"
    local target_path="$3"
    local command=""
    local start_time end_time elapsed_time

    start_time=$(date +%s)

    log_message "Starting refactoring of $target_path with $tool_name..."

    case "$tool_name" in
    "rector")
        command="$COMPOSER_BIN_DIR/rector process \"$target_path\" --config \"$tool_config\" --no-progress-bar"
        ;;
    "ecs")
        command="$COMPOSER_BIN_DIR/ecs check \"$target_path\" --fix --config \"$tool_config\" --output-format=console"
        ;;
    "php-cs-fixer")
        command="$COMPOSER_BIN_DIR/php-cs-fixer fix \"$target_path\" --config=\"$tool_config\" --no-interaction"
        ;;
    "pint")
        command="$COMPOSER_BIN_DIR/pint \"$target_path\""
        ;;
    esac

    eval $command

    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))

    if [ $? -eq 0 ]; then
        log_message "${GREEN}$tool_name successfully refactored $target_path in $elapsed_time seconds.${NC}"
    else
        log_message "${RED}$tool_name encountered an error while refactoring $target_path. Please check logs for details.${NC}"
    fi
}

apply_all_refactoring_tools() {
    local target_path="$1"
    run_refactoring_tool "rector" "$RECTOR_CONFIG" "$target_path"
    run_refactoring_tool "ecs" "$ECS_CONFIG" "$target_path"
    run_refactoring_tool "php-cs-fixer" "$PHPCS_FIXER_CONFIG" "$target_path"
    run_refactoring_tool "pint" "$PINT_CONFIG" "$target_path"
}

refactor_directory() {
    local directory_path="$1"
    local tool_name="$2"
    local tool_config="$3"

    local php_files_count=$(find "$directory_path" -type f -name "*.php" -not -path "*/vendor/*" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/cache/*" -not -path "*/build/*" -not -path "*/dist/*" -not -path "*/logs/*" -not -path "*/public/*" -not -path "*/assets/*" | wc -l)

    if [ "$php_files_count" -eq 0 ]; then
        log_message "${RED}No PHP files found in the directory: $directory_path${NC}"
        return 1
    fi

    log_message "Found $php_files_count PHP files in $directory_path. Starting refactoring..."

    find "$directory_path" -type f -name "*.php" -not -path "*/vendor/*" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/cache/*" -not -path "*/build/*" -not -path "*/dist/*" -not -path "*/logs/*" -not -path "*/public/*" -not -path "*/assets/*" | while read -r php_file; do
        if [ "$tool_name" == "apply_all" ]; then
            apply_all_refactoring_tools "$php_file"
        else
            run_refactoring_tool "$tool_name" "$tool_config" "$php_file"
        fi
    done
}

validate_and_refactor() {
    local path_input="$1"
    local tool_name="$2"
    local tool_config="$3"

    if [ -f "$path_input" ] && [ "${path_input##*.}" == "php" ]; then
        log_message "${GREEN}Valid PHP file detected: $path_input${NC}"
        if [[ "$tool_name" == "apply_all" ]]; then
            apply_all_refactoring_tools "$path_input"
        else
            run_refactoring_tool "$tool_name" "$tool_config" "$path_input"
        fi
    elif [ -d "$path_input" ]; then
        log_message "${GREEN}Directory detected: $path_input${NC}"
        refactor_directory "$path_input" "$tool_name" "$tool_config"
    else
        log_message "${RED}Invalid input. Please provide a valid PHP file or directory.${NC}"
        return 1
    fi
    return 0
}

show_main_menu() {
    echo "Select an option:"
    echo "1) Refactor a PHP file"
    echo "2) Refactor all PHP files in a directory"
    echo "3) Quit"
}

show_tool_selection_menu() {
    echo "Select a refactoring tool:"
    echo "1) Refactor with RectorPHP"
    echo "2) Refactor with Easy Coding Standard"
    echo "3) Refactor with PHP CS Fixer"
    echo "4) Refactor with Laravel Pint"
    echo "5) Apply All"
    echo "6) Back to main menu"
}

show_post_refactor_menu() {
    echo "What would you like to do next?"
    echo "1) Back to main menu"
    echo "2) Select another refactoring tool"
    echo "3) Quit"
}

setup_global_script_access() {
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

    log_message "${GREEN}Script has been copied to ~/bin and made executable globally.${NC}"
    log_message "${GREEN}You can now run the script from anywhere using '$SCRIPT_NAME'.${NC}"
}

check_and_setup_global_access() {
    if [[ "$0" != "$SCRIPT_PATH" ]]; then
        log_message "${YELLOW}The script is not in the global executable location.${NC}"
        read -p "Do you want to set up this script for global access? (y/n): " setup_choice
        setup_choice=$(echo "$setup_choice" | tr '[:upper:]' '[:lower:]')
        case "$setup_choice" in
        y | yes)
            setup_global_script_access
            log_message "${GREEN}Please re-run the script using '$SCRIPT_NAME' command.${NC}"
            exit 0
            ;;
        *)
            log_message "${YELLOW}Global setup skipped. You can still move and make it executable manually later.${NC}"
            ;;
        esac
    else
        log_message "${GREEN}The script is already in the global executable location.${NC}"
    fi
}

main() {
    check_and_setup_global_access
    ensure_dependencies_installed

    while true; do
        show_main_menu
        read -p "Enter your choice: " main_choice
        case "$main_choice" in
        1 | 2)
            while true; do
                show_tool_selection_menu
                read -p "Enter your choice: " tool_choice
                case "$tool_choice" in
                1)
                    tool_name="rector"
                    tool_config="$RECTOR_CONFIG"
                    ;;
                2)
                    tool_name="ecs"
                    tool_config="$ECS_CONFIG"
                    ;;
                3)
                    tool_name="php-cs-fixer"
                    tool_config="$PHPCS_FIXER_CONFIG"
                    ;;
                4)
                    tool_name="pint"
                    tool_config="$PINT_CONFIG"
                    ;;
                5)
                    tool_name="apply_all"
                    ;;
                6)
                    log_message "${YELLOW}Returning to the main menu.${NC}"
                    break
                    ;;
                *)
                    log_message "${RED}Invalid option. Please try again.${NC}"
                    continue
                    ;;
                esac

                if [[ "$tool_choice" -ge 1 && "$tool_choice" -le 5 ]]; then
                    read -p "Enter the full path of the PHP file or directory to refactor (or type 'q' to quit): " path_input
                    if [[ "$path_input" == "q" ]]; then
                        log_message "${YELLOW}Quitting the script. Goodbye!${NC}"
                        break 2
                    fi

                    validate_and_refactor "$path_input" "$tool_name" "$tool_config"

                    read -p "Do you want to refactor another file or directory with the same tool? (y/N): " continue_choice
                    if [[ "$continue_choice" != "y" && "$continue_choice" != "yes" ]]; then
                        while true; do
                            show_post_refactor_menu
                            read -p "Enter your choice: " post_refactor_choice
                            case "$post_refactor_choice" in
                            1)
                                log_message "${YELLOW}Returning to the main menu.${NC}"
                                break 2
                                ;;
                            2)
                                log_message "${YELLOW}Selecting another refactoring tool.${NC}"
                                break
                                ;;
                            3)
                                log_message "${YELLOW}Quitting the script. Goodbye!${NC}"
                                exit 0
                                ;;
                            *)
                                log_message "${RED}Invalid option. Please try again.${NC}"
                                ;;
                            esac
                        done
                    fi
                fi
            done
            ;;
        3)
            log_message "${YELLOW}Quitting the script. Goodbye!${NC}"
            exit 0
            ;;
        *)
            log_message "${RED}Invalid option. Please try again.${NC}"
            ;;
        esac
    done
}

main
