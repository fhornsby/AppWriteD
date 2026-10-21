<?php

namespace AppwriteD\Generator;

use Appwrite\SDK\Language;
use Appwrite\SDK\SDK as BaseSDK;
use Twig\Loader\FilesystemLoader;
use Utopia\OpenAPI\Specification;

/**
 * The upstream SDK class loads templates from its own package only. This
 * subclass puts this repository's templates first on the Twig search path, so
 * the D language can live outside appwrite/sdk-generator without a fork.
 */
class SDK extends BaseSDK
{
    public function __construct(Language $language, Specification $spec)
    {
        parent::__construct($language, $spec);

        $loader = $this->twig->getLoader();
        if ($loader instanceof FilesystemLoader) {
            $loader->prependPath(__DIR__ . '/../templates');
        }
    }
}
