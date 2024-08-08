# PHP Refactor Toolkit

## Overview

The PHP Refactor Toolkit is a comprehensive script designed to streamline and automate the refactoring of PHP code. It leverages several powerful tools to ensure your code adheres to best practices and modern coding standards.

## Features

- **RectorPHP:** Automated code refactoring.
- **Easy Coding Standard (ECS):** Enforces coding standards.
- **PHP CS Fixer:** Fixes code to follow standards.
- **Laravel Pint:** Laravel-specific code formatting.

## Prerequisites

- **PHP:** Ensure you have PHP version 8.3 or higher installed. This toolkit is designed for modern coding practices, and it helps migrate old version syntaxes to new upgraded versions.
- **Composer:** Ensure Composer is installed for managing PHP dependencies.
- **Zsh or Bash:** This toolkit can be configured for either Zsh or Bash shell environments.

## Installation

### Automated Installation

You can install the toolkit using the following command:

```sh
curl -sL https://github.com/SHSharkar/PHP-Refactor-Toolkit/raw/main/installer.sh | bash
```

This command will:

1. Clone the repository to your home directory.
2. Copy the necessary configuration files.
3. Set up the script for global access.

### Manual Installation

If you prefer to install manually, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/SHSharkar/PHP-Refactor-Toolkit ~/php_refactor_toolkit
    ```

2. Copy the configuration files:
    ```sh
    cp ~/php_refactor_toolkit/rector.php ~/
    cp ~/php_refactor_toolkit/.ecs.php ~/
    cp ~/php_refactor_toolkit/.php-cs-fixer.php ~/
    cp ~/php_refactor_toolkit/pint.json ~/
    ```

3. Set up the script:
    ```sh
    mkdir -p ~/bin
    cp ~/php_refactor_toolkit/php_refactor_toolkit.sh ~/bin/php_refactor_toolkit
    chmod +x ~/bin/php_refactor_toolkit
    ```

4. Add `~/bin` to your `PATH` in your shell configuration file (`.zshrc` or `.bashrc`):
    ```sh
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.zshrc
    source ~/.zshrc
    ```

## Usage

To run the toolkit, simply execute:

```sh
php_refactor_toolkit
```

You will be presented with a menu to select the desired refactoring tool or apply all tools to a PHP file.

### Example Usage

1. Select an option from the menu:
    ```sh
    1) Refactor with RectorPHP
    2) Refactor with Easy Coding Standard
    3) Refactor with PHP CS Fixer
    4) Refactor with Laravel Pint
    5) Apply All
    6) Quit
    ```

2. Enter the full path of the PHP file to refactor when prompted.

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please open an issue on the [GitHub repository](https://github.com/SHSharkar/PHP-Refactor-Toolkit/issues).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](https://github.com/SHSharkar/PHP-Refactor-Toolkit/blob/main/LICENSE) file for details.

## Contact

For any further queries, please contact the repository maintainer via the GitHub repository.
