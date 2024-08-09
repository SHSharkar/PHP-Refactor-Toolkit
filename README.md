# PHP Refactor Toolkit

## Overview

The PHP Refactor Toolkit is a comprehensive script designed to streamline and automate the refactoring of PHP code. It leverages several powerful tools to ensure your code adheres to best practices and modern coding standards.

## Features

- **RectorPHP:** Automated code refactoring.
- **Easy Coding Standard (ECS):** Enforces coding standards.
- **PHP CS Fixer:** Fixes code to follow standards.
- **Laravel Pint:** Laravel-specific code formatting.

## Prerequisites

- **PHP:** Ensure you have PHP version 8.3 or higher installed. This toolkit is designed for modern coding practices and helps migrate old version syntaxes to new upgraded versions.
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

   For Bash:

   ```sh
   echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
   source ~/.bashrc
   ```

## Usage

Once installed, you can run the PHP Refactor Toolkit using the following command:

```sh
php_refactor_toolkit
```

### Menu Options

The toolkit provides a user-friendly menu with the following options:

1. **Refactor a PHP file:** Choose this option to refactor a single PHP file using one of the supported tools.
2. **Refactor all PHP files in a directory:** This option allows you to refactor all PHP files within a specified directory.
3. **Quit:** Exit the script.

### Tool Selection

After selecting a file or directory, you'll be prompted to choose a refactoring tool:

1. **RectorPHP:** For automated code refactoring.
2. **Easy Coding Standard (ECS):** To enforce coding standards.
3. **PHP CS Fixer:** For fixing code style issues.
4. **Laravel Pint:** For Laravel-specific formatting.
5. **Apply All:** Apply all the above tools sequentially.
6. **Back to main menu:** Return to the main menu to select a different option.

### Refactoring Process

The toolkit will guide you through the refactoring process. If you choose to refactor another file or directory after completing a task, you can either continue with the same tool or return to the main menu to choose a different tool.

Verbose output, including diffs and applied changes, will be displayed to provide insight into what changes were made by each tool.

## Issues and Contributions

We welcome contributions and encourage you to report any issues or feature requests. Please visit the [GitHub Issues page](https://github.com/SHSharkar/PHP-Refactor-Toolkit/issues) to report any bugs or request new features.

If you would like to contribute to the project, feel free to fork the repository, make your changes, and submit a pull request. We appreciate all contributions that help improve the PHP Refactor Toolkit.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/SHSharkar/PHP-Refactor-Toolkit/blob/main/LICENSE) file for more details.
