<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\ArrayNotation\ArraySyntaxFixer;
use Symplify\EasyCodingStandard\Config\ECSConfig;
use Symplify\EasyCodingStandard\ValueObject\Option;
use Symplify\EasyCodingStandard\ValueObject\Set\SetList;

return static function (ECSConfig $ecsConfig): void {
    $ecsConfig->indentation(Option::INDENTATION_SPACES);

    $ecsConfig->lineEnding(\PHP_EOL);

    $ecsConfig->parallel();

    $ecsConfig->sets([
        SetList::PSR_12,
        SetList::CLEAN_CODE,
        SetList::COMMON,
        SetList::SYMPLIFY,
        SetList::ARRAY,
        SetList::COMMENTS,
        SetList::DOCTRINE_ANNOTATIONS,
        SetList::NAMESPACES,
    ]);

    $ecsConfig->ruleWithConfiguration(ArraySyntaxFixer::class, [
        'syntax' => 'short',
    ]);
};
