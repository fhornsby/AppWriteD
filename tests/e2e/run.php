<?php

/**
 * End-to-end test helpers, driven by tests/e2e/run.sh:
 *
 *   php run.php generate             generate the D SDK from the sdk-generator test fixture into ./sdk
 *   php run.php compare output.txt   compare the e2e program's output with the expectations
 *                                    the upstream e2e suite holds every SDK to
 */

namespace PHPUnit\Framework {
    // Base.php extends TestCase; only its constants are needed here.
    if (!class_exists(TestCase::class)) {
        abstract class TestCase
        {
            public function setUp(): void
            {
            }

            public function tearDown(): void
            {
            }
        }
    }
}

namespace {
    require __DIR__ . '/../../generator/vendor/autoload.php';
    require __DIR__ . '/../../generator/vendor/appwrite/sdk-generator/tests/e2e/Base.php';

    use AppwriteD\Generator\D;
    use AppwriteD\Generator\SDK;
    use Tests\E2E\Base;
    use Utopia\OpenAPI\Parser;

    $upstream = __DIR__ . '/../../generator/vendor/appwrite/sdk-generator';
    $sdkDir = __DIR__ . '/sdk';
    $mode = $argv[1] ?? '';

    if ($mode === 'generate') {
    // Generate with the settings the upstream suite uses.
    $sdk = new SDK((new D())->setPackageName('appwrited'), Parser::parse(file_get_contents("{$upstream}/tests/resources/spec-openapi3.json")));
    $sdk->setName('d')
        ->setVersion('0.0.1')
        ->setPlatform('client')
        ->setNamespace('appwrite')
        ->setDescription('Repo description goes here')
        ->setShortDescription('Repo short description goes here')
        ->setGitUserName('repoowner')
        ->setGitRepoName('reponame')
        ->setLicense('BSD-3-Clause')
        ->setLicenseContent('demo license')
        ->setChangelog('--changelog--')
        ->setDefaultHeaders(['X-Appwrite-Response-Format' => '0.8.0'])
        ->setExclude([
            'services' => [['name' => 'zzexcludedservice']],
            'methods' => [['name' => 'createExcludedGeneralFixture']],
        ])
        ->setTest('true');
    exec('rm -rf ' . escapeshellarg($sdkDir));
    $sdk->generate($sdkDir);
    echo "Generated the test SDK in {$sdkDir}\n";
    exit(0);
    }

    if ($mode !== 'compare' || !isset($argv[2])) {
        fwrite(STDERR, "usage: php run.php generate | compare <output file>\n");
        exit(2);
    }

    $output = explode("\n", rtrim((string) file_get_contents($argv[2]), "\n"));
    while ($output !== [] && array_shift($output) !== 'Test Started') {
    }

    $constants = (new ReflectionClass(Base::class))->getConstants();
    $groups = [
        'PING_RESPONSE', 'FOO_RESPONSES', 'BAR_RESPONSES', 'GENERAL_RESPONSES', 'PATH_VALIDATION_RESPONSES',
        'NULL_PATH_RESPONSE', 'TEXT_RESPONSES', 'TEXT_UPLOAD_RESPONSES', 'OPTIONAL_ATTACHMENT_RESPONSES',
        'MULTIPART_OBJECT_RESPONSES', 'UPLOAD_RESPONSES', 'GENERIC_UPLOAD_RESPONSES', 'DOWNLOAD_RESPONSES',
        'ENUM_RESPONSES', 'OPTIONAL_PARAM_RESPONSES', 'MODEL_RESPONSES', 'MODEL_DEFAULT_RESPONSES', 'NULLABLE_MODEL_RESPONSES',
        'ENUM_ARRAY_MODEL_RESPONSES', 'MAP_MODEL_DEFAULT_RESPONSES', 'NESTED_MODEL_DEFAULT_RESPONSES',
        'EXCEPTION_RESPONSES', 'REALTIME_RESPONSES', 'COOKIE_RESPONSES', 'QUERY_HELPER_RESPONSES',
        'QUERY_TRANSPORT_RESPONSE', 'PERMISSION_HELPER_RESPONSES', 'ID_HELPER_RESPONSES',
        'CHANNEL_HELPER_RESPONSES', 'OPERATOR_HELPER_RESPONSES',
    ];
    $expected = [];
    foreach ($groups as $group) {
        $value = $constants[$group];
        array_push($expected, ...(is_array($value) ? $value : [$value]));
    }

    $failures = 0;
    foreach ($expected as $index => $line) {
        $actual = $output[$index] ?? '<missing>';
        $ok = match (true) {
            $line === $constants['HEADERS_RESPONSE'] => $actual === 'x-sdk-name: d; x-sdk-platform: client; x-sdk-language: d; x-sdk-version: 0.0.1; accept: application/json, text/plain',
            $line === $constants['QUERY_TRANSPORT_RESPONSE'] => queriesMatch($actual, $constants['QUERY_TRANSPORT_QUERIES']),
            str_starts_with($line, '{') => json_decode($line, true) == json_decode($actual, true),
            $line === 'unique()' => strlen($actual) === 20 && $actual !== 'unique()',
            default => $line === $actual,
        };
        if (!$ok) {
            $failures++;
            fwrite(STDERR, "line {$index}: expected {$line}\n         got      {$actual}\n");
        }
    }
    if (count($output) > count($expected)) {
        $failures++;
        fwrite(STDERR, "unexpected extra output:\n" . implode("\n", array_slice($output, count($expected))) . "\n");
    }

    $total = count($expected);
    if ($failures > 0) {
        fwrite(STDERR, "{$failures} of {$total} checks failed\n");
        exit(1);
    }
    echo "All {$total} e2e checks passed\n";

    function queriesMatch(string $echo, array $queries): bool
    {
        $received = json_decode($echo, true);
        if (!is_array($received) || count($received) !== count($queries)) {
            return false;
        }
        foreach ($queries as $position => $query) {
            if (json_decode($query, true) != json_decode((string) $received[$position], true)) {
                return false;
            }
        }
        return true;
    }
}
