<?php

/**
 * Generate the D client SDK from an Appwrite OpenAPI 3 specification.
 *
 *   php generate.php [--spec-version=2.5.x] [--spec-commit=sha|main] [--spec-file=path] [--version=x.y.z] [--out=dir]
 *
 * By default the spec is downloaded from github.com/appwrite/specs and the SDK
 * is written to the repository root (the directory above this one). Only the
 * generated paths are replaced; the generator itself is never touched.
 */

require __DIR__ . '/vendor/autoload.php';

use AppwriteD\Generator\D;
use AppwriteD\Generator\SDK;
use Utopia\OpenAPI\Parser;

$options = getopt('', ['spec-version:', 'spec-commit:', 'spec-file:', 'version:', 'out:', 'platform:']);
$config = json_decode((string) file_get_contents(__DIR__ . '/config.json'), true, flags: JSON_THROW_ON_ERROR);

$specVersion = $options['spec-version'] ?? $config['specVersion'];
// Specs are read from a pinned commit of appwrite/specs so generation is reproducible.
$specCommit = $options['spec-commit'] ?? $config['specCommit'] ?? 'main';
$version = $options['version'] ?? $config['version'];
$platform = $options['platform'] ?? 'client';
$out = rtrim($options['out'] ?? dirname(__DIR__), '/');

$specFile = $options['spec-file'] ?? getenv('SDK_GEN_SPEC_FILE') ?: null;
if ($specFile !== null) {
    $spec = file_get_contents($specFile);
} else {
    $url = "https://raw.githubusercontent.com/appwrite/specs/{$specCommit}/specs/{$specVersion}/open-api3-{$specVersion}.json";
    fwrite(STDERR, "Downloading {$url}\n");
    $spec = file_get_contents($url);
}
if ($spec === false || $spec === '') {
    fwrite(STDERR, "Could not read the specification\n");
    exit(1);
}

$language = new D();
$language->setPackageName($config['packageName']);

$sdk = new SDK($language, Parser::parse($spec));
$sdk->setName($config['name'])
    ->setNamespace('appwrite')
    ->setVersion($version)
    ->setPlatform($platform)
    ->setDescription($config['description'])
    ->setShortDescription($config['shortDescription'])
    ->setURL($config['url'])
    ->setLicense($config['license'])
    ->setLicenseContent((string) file_get_contents(__DIR__ . '/' . $config['licenseFile']))
    ->setGitUserName($config['gitUserName'])
    ->setGitRepoName($config['gitRepoName'])
    ->setChangelog((string) file_get_contents(__DIR__ . '/' . $config['changelogFile']))
    ->setReadme('')
    ->setTwitter('appwrite')
    ->setDiscord('564160730845151244', 'https://appwrite.io/discord')
    ->setExclude($config['exclude'] ?? []);

// Generate into a scratch directory first, so a failed run leaves the
// previously generated SDK untouched.
$scratch = sys_get_temp_dir() . '/appwrite-d-' . bin2hex(random_bytes(4));
$sdk->generate($scratch);

// Paths the generator owns. Everything else under $out is left alone.
$owned = ['source/appwrite', 'docs/examples', 'examples', 'dub.json', 'README.md', 'CHANGELOG.md', 'LICENSE', '.gitignore'];
foreach ($owned as $path) {
    removePath("{$out}/{$path}");
    if (file_exists("{$scratch}/{$path}")) {
        copyPath("{$scratch}/{$path}", "{$out}/{$path}");
    }
}
removePath($scratch);

fwrite(STDERR, "Generated the D SDK (API {$specVersion}, platform {$platform}) in {$out}\n");

function removePath(string $path): void
{
    if (is_link($path) || is_file($path)) {
        unlink($path);
        return;
    }
    if (!is_dir($path)) {
        return;
    }
    foreach (scandir($path) as $entry) {
        if ($entry !== '.' && $entry !== '..') {
            removePath("{$path}/{$entry}");
        }
    }
    rmdir($path);
}

function copyPath(string $from, string $to): void
{
    if (is_file($from)) {
        if (!is_dir(dirname($to))) {
            mkdir(dirname($to), 0777, true);
        }
        copy($from, $to);
        return;
    }
    foreach (scandir($from) as $entry) {
        if ($entry !== '.' && $entry !== '..') {
            copyPath("{$from}/{$entry}", "{$to}/{$entry}");
        }
    }
}
