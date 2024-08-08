<?php

$finder = Symfony\Component\Finder\Finder::create()
    ->in(__DIR__)
    ->name('*.php')
    ->ignoreDotFiles(true)
    ->ignoreVCS(true)
    ->exclude(['vendor', 'node_modules', 'storage/logs', 'storage/framework', 'storage/debugbar', 'public', 'bootstrap/cache']);

return (new PhpCsFixer\Config())
    ->setRules([
        '@PHP80Migration' => true,
        '@PHP80Migration:risky' => true,
        '@PHP81Migration' => true,
        '@PSR12:risky' => true,
        '@PSR2' => true,
        '@PhpCsFixer' => true,
        '@PhpCsFixer:risky' => true,
        '@Symfony:risky' => true,
        'declare_strict_types' => false,
        'blank_line_before_statement' => [
            'statements' => [
                'break',
                'case',
                'continue',
                'declare',
                'default',
                'do',
                'exit',
                'for',
                'foreach',
                'goto',
                'if',
                'include',
                'include_once',
                'phpdoc',
                'require',
                'require_once',
                'return',
                'switch',
                'throw',
                'try',
                'while',
                'yield',
                'yield_from',
            ],
        ],
        'multiline_whitespace_before_semicolons' => [
            'strategy' => 'new_line_for_chained_calls',
        ],
        'concat_space' => [
            'spacing' => 'one',
        ],
        'phpdoc_align' => [
            'align' => 'left',
        ],
        'single_quote' => ['strings_containing_single_quote_chars' => true],
        'space_after_semicolon' => ['remove_in_empty_for_expressions' => true],
        'whitespace_after_comma_in_array' => ['ensure_single_space' => true],
        'ordered_imports' => [
            'imports_order' => ['const', 'class', 'function'],
        ],
        'no_superfluous_phpdoc_tags' => [
            'remove_inheritdoc' => true,
        ],
        'header_comment' => [
            'comment_type' => 'PHPDoc',
            'header' => '',
        ],
        'global_namespace_import' => [
            'import_classes' => true,
            'import_constants' => true,
            'import_functions' => true,
        ],
        'yoda_style' => [
            'equal' => true,
            'identical' => false,
            'less_and_greater' => false,
        ],
    ])
    ->setRiskyAllowed(true)
    ->setIndent('    ')
    ->setLineEnding("\n")
    ->setFinder($finder);
