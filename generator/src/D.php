<?php

namespace AppwriteD\Generator;

use Appwrite\SDK\Language;
use Override;
use Twig\TwigFilter;
use Utopia\OpenAPI\Model\ArraySchema;
use Utopia\OpenAPI\Model\Operation;
use Utopia\OpenAPI\Model\Parameter;
use Utopia\OpenAPI\Model\Schema;
use Utopia\OpenAPI\Specification;

/**
 * D language target for the Appwrite SDK generator.
 *
 * Produces a dub package for client-side (end user) applications: desktop
 * apps, games and UI toolkits written in D. Networking is built on Phobos'
 * std.net.curl, so the generated package has no third-party dependencies.
 */
class D extends Language
{
    /**
     * Identifiers D reserves, plus names the generated code relies on and
     * must therefore never be shadowed by a field, parameter or method.
     */
    protected const array RESERVED = [
        // Keywords
        'abstract', 'alias', 'align', 'asm', 'assert', 'auto', 'body', 'bool',
        'break', 'byte', 'case', 'cast', 'catch', 'cdouble', 'cent', 'cfloat',
        'char', 'class', 'const', 'continue', 'creal', 'dchar', 'debug',
        'default', 'delegate', 'delete', 'deprecated', 'do', 'double', 'else',
        'enum', 'export', 'extern', 'false', 'final', 'finally', 'float', 'for',
        'foreach', 'foreach_reverse', 'function', 'goto', 'idouble', 'if',
        'ifloat', 'immutable', 'import', 'in', 'inout', 'int', 'interface',
        'invariant', 'ireal', 'is', 'lazy', 'long', 'macro', 'mixin', 'module',
        'new', 'nothrow', 'null', 'out', 'override', 'package', 'pragma',
        'private', 'protected', 'public', 'pure', 'real', 'ref', 'return',
        'scope', 'shared', 'short', 'static', 'struct', 'super', 'switch',
        'synchronized', 'template', 'this', 'throw', 'true', 'try', 'typeid',
        'typeof', 'ubyte', 'ucent', 'uint', 'ulong', 'union', 'unittest',
        'ushort', 'version', 'void', 'wchar', 'while', 'with',
        // Built-in properties that cannot be redeclared as members
        'init', 'sizeof', 'alignof', 'mangleof', 'stringof', 'tupleof',
        'offsetof',
        // Names from object.d and the generated code's own imports
        'string', 'wstring', 'dstring', 'size_t', 'ptrdiff_t', 'Object',
        'Exception', 'Error', 'Nullable', 'JSONValue', 'models', 'enums',
        'client', 'toString', 'toJson', 'fromJson', 'opIndex', 'convertTo',
    ];

    /**
     * Type names that would collide with a D built-in or with names that
     * `import appwrite;` already brings into scope.
     */
    protected const array TYPE_OVERRIDES = [
        'Error' => 'AppwriteError',
        'Exception' => 'AppwriteExceptionModel',
        'Object' => 'AppwriteObject',
        'Client' => 'ClientModel',
        'Service' => 'ServiceModel',
        'Response' => 'ResponseModel',
        'Query' => 'QueryModel',
        'Role' => 'RoleModel',
        'Permission' => 'PermissionModel',
        'ID' => 'IDModel',
        'Channel' => 'ChannelModel',
        'Operator' => 'OperatorModel',
        'Realtime' => 'RealtimeModel',
        'InputFile' => 'InputFileModel',
    ];

    #[Override]
    protected $params = [
        'packageName' => 'appwrite',
        'description' => '',
    ];

    public function setPackageName(string $name): self
    {
        $this->setParam('packageName', $name);

        return $this;
    }

    public function getName(): string
    {
        return 'D';
    }

    public function getKeywords(): array
    {
        return self::RESERVED;
    }

    public function getIdentifierOverrides(): array
    {
        $overrides = [];
        foreach (self::RESERVED as $word) {
            $overrides[$word] = $word . '_';
        }

        return $overrides;
    }

    /**
     * D convention is a trailing underscore for identifiers that would
     * otherwise collide with a keyword (`delete_`, `function_`).
     */
    #[Override]
    public function escapeKeyword(string $value): string
    {
        return \in_array($value, self::RESERVED, true) ? $value . '_' : $value;
    }

    public function getStaticAccessOperator(): string
    {
        return '.';
    }

    public function getStringQuote(): string
    {
        return '"';
    }

    public function getArrayOf(string $elements): string
    {
        return '[' . $elements . ']';
    }

    public function getFiles(): array
    {
        $files = [];
        $default = [
            'dub.json',
            'README.md',
            'CHANGELOG.md',
            'LICENSE',
            '.gitignore',
            'source/appwrite/package.d',
            'source/appwrite/client.d',
            'source/appwrite/service.d',
            'source/appwrite/exception.d',
            'source/appwrite/json.d',
            'source/appwrite/cookies.d',
            'source/appwrite/input_file.d',
            'source/appwrite/upload_progress.d',
            'source/appwrite/id.d',
            'source/appwrite/permission.d',
            'source/appwrite/role.d',
            'source/appwrite/query.d',
            'source/appwrite/operator.d',
            'source/appwrite/channel.d',
            'source/appwrite/realtime.d',
            'source/appwrite/websocket.d',
            'source/appwrite/curl.d',
            'source/appwrite/async.d',
            'source/appwrite/oauth.d',
            'source/appwrite/models/package.d',
            'source/appwrite/enums/package.d',
            'source/appwrite/services/package.d',
            'examples/basic/dub.json',
            'examples/basic/source/app.d',
            'examples/realtime/dub.json',
            'examples/realtime/source/app.d',
        ];
        foreach ($default as $path) {
            $files[] = [
                'scope' => 'default',
                'destination' => $path,
                'template' => 'd/' . $path . '.twig',
            ];
        }

        return [
            ...$files,
            [
                'scope' => 'service',
                'destination' => 'source/appwrite/services/{{ service.name | dModule }}.d',
                'template' => 'd/source/appwrite/services/service.d.twig',
            ],
            [
                'scope' => 'definition',
                'destination' => 'source/appwrite/models/{{ definitionName | dModule }}.d',
                'template' => 'd/source/appwrite/models/model.d.twig',
            ],
            [
                'scope' => 'requestModel',
                'destination' => 'source/appwrite/models/{{ requestModelName | dModule }}.d',
                'template' => 'd/source/appwrite/models/request_model.d.twig',
            ],
            [
                'scope' => 'enum',
                'destination' => 'source/appwrite/enums/{{ enum.title | dModule }}.d',
                'template' => 'd/source/appwrite/enums/enum.d.twig',
            ],
            [
                'scope' => 'method',
                'destination' => 'docs/examples/{{ service.name | caseLower }}/{{ (method | methodName) | caseKebab }}.md',
                'template' => 'd/docs/example.md.twig',
            ],
        ];
    }

    public function getTypeName(Schema|Parameter $parameter, ?Specification $spec = null): string
    {
        $schema = $this->getSchema($parameter);
        if ($this->usesEnumType($parameter)) {
            $type = 'enums.' . $this->toTypeName($this->getSchemaEnumName($parameter, $spec));
            return $schema instanceof ArraySchema ? $type . '[]' : $type;
        }

        $model = $schema instanceof ArraySchema
            ? $this->getArraySchemaModel($schema)
            : $this->getSchemaModel($schema);
        if ($model !== null) {
            $type = $model === 'any' ? 'JSONValue' : 'models.' . $this->toTypeName($model);
            return $schema instanceof ArraySchema ? $type . '[]' : $type;
        }

        return match ($this->getSchemaType($parameter)) {
            self::TYPE_INTEGER => 'long',
            self::TYPE_NUMBER => 'double',
            self::TYPE_FILE => 'InputFile',
            self::TYPE_STRING => 'string',
            self::TYPE_BOOLEAN => 'bool',
            self::TYPE_ARRAY => match (true) {
                $this->isUntypedNestedArray($parameter, $schema) => 'JSONValue[][]',
                !$this->hasConcreteItemsType($schema) => 'JSONValue[]',
                default => $this->getTypeName($schema->items) . '[]',
            },
            default => 'JSONValue',
        };
    }

    /** PascalCase type name with collision overrides applied. */
    public function toTypeName(string $name): string
    {
        $type = $this->toPascalCase($name);

        return self::TYPE_OVERRIDES[$type] ?? $type;
    }

    /**
     * How a value of this type is optional in D:
     *  - `nullable`: wrapped in std.typecons.Nullable (booleans, models; numbers in models)
     *  - `sentinel`: a number parameter defaulting to `unset!T`, so callers write `width: 256`
     *  - `null`: the type itself can be null (strings, arrays, string enums, classes)
     *  - `json`: a JSONValue whose type is null
     */
    protected function getOptionalKind(Schema|Parameter $value, ?Specification $spec = null, bool $forParam = false): string
    {
        $type = $this->getTypeName($value, $spec);

        return match (true) {
            \str_ends_with($type, '[]'), $type === 'string', $type === 'InputFile',
            \str_starts_with($type, 'enums.') => 'null',
            $type === 'JSONValue' => 'json',
            $forParam && ($type === 'long' || $type === 'double') => 'sentinel',
            default => 'nullable',
        };
    }

    /** The parameter type a generated method declares. */
    protected function getParamType(Parameter $parameter, ?Specification $spec = null): string
    {
        $type = $this->getTypeName($parameter, $spec);
        if ($this->isRequiredParam($parameter) || $this->getOptionalKind($parameter, $spec, true) !== 'nullable') {
            return $type;
        }

        return 'Nullable!(' . $type . ')';
    }

    protected function isRequiredParam(Parameter $parameter): bool
    {
        return $parameter->required && !$this->getSchema($parameter)->nullable;
    }

    /** Declaration of a method parameter, with its default when optional. */
    protected function getParamDeclaration(Parameter $parameter, ?Specification $spec = null): string
    {
        $name = $this->getParamName($parameter);
        $type = $this->getParamType($parameter, $spec);
        if ($this->isRequiredParam($parameter)) {
            return $type . ' ' . $name;
        }

        $default = match ($this->getOptionalKind($parameter, $spec, true)) {
            'nullable' => $type . '.init',
            'sentinel' => 'unset!' . $type,
            'json' => 'JSONValue.init',
            default => \str_starts_with($type, 'enums.') && !\str_ends_with($type, '[]')
                ? 'cast(' . $type . ') null'
                : 'null',
        };

        return $type . ' ' . $name . ' = ' . $default;
    }

    /** Expression that is true when an optional parameter was supplied. */
    protected function getParamIsSet(Parameter $parameter, ?Specification $spec = null): string
    {
        $name = $this->getParamName($parameter);

        return match ($this->getOptionalKind($parameter, $spec, true)) {
            'nullable' => '!' . $name . '.isNull',
            'sentinel' => 'isSet(' . $name . ')',
            'json' => $name . '.type != JSONType.null_',
            default => $name . ' !is null',
        };
    }

    /** Expression serializing a parameter for the request. */
    protected function getParamValue(Parameter $parameter, ?Specification $spec = null): string
    {
        $name = $this->getParamName($parameter);
        if ($parameter->required && $this->getSchema($parameter)->nullable) {
            return match ($this->getOptionalKind($parameter, $spec, true)) {
                'null' => $name . ' is null ? JSONValue(null) : serialize(' . $name . ')',
                'sentinel' => 'isSet(' . $name . ') ? serialize(' . $name . ') : JSONValue(null)',
                default => 'serialize(' . $name . ')',
            };
        }

        return 'serialize(' . $name . ')';
    }

    /** Expression for a path parameter's segment. */
    protected function getPathValue(Parameter $parameter, ?Specification $spec = null): string
    {
        $name = $this->getParamName($parameter);
        $type = $this->getTypeName($parameter, $spec);
        $kind = $this->getOptionalKind($parameter, $spec, true);
        $required = $this->isRequiredParam($parameter);

        $text = match (true) {
            $type === 'string' => $name,
            \str_starts_with($type, 'enums.') => 'cast(string) ' . $name,
            $kind === 'nullable' && !$required => $name . '.get.to!string',
            default => $name . '.to!string',
        };
        $value = 'encodeComponent(' . $text . ')';

        if ($required) {
            return $value;
        }

        return match ($kind) {
            'nullable' => '(' . $name . '.isNull ? "null" : ' . $value . ')',
            'sentinel' => '(isSet(' . $name . ') ? ' . $value . ' : "null")',
            default => '(' . $name . ' is null ? "null" : ' . $value . ')',
        };
    }

    public function getParamName(Parameter|string $parameter): string
    {
        $name = $parameter instanceof Parameter ? $parameter->name : $parameter;

        return $this->escapeKeyword($this->toCamelCase($name));
    }

    /** Field name for a model property, e.g. `$createdAt` -> `createdAt`. */
    public function getFieldName(string $propertyName): string
    {
        $camel = \preg_match('/^_?[A-Z_]+$/', $propertyName)
            ? $this->toCamelCase(\strtolower($propertyName))
            : $this->toCamelCase($propertyName);
        if ($camel === '' || \ctype_digit($camel[0])) {
            $camel = 'field' . \ucfirst($camel);
        }

        return $this->escapeKeyword($camel);
    }

    /** The D type a model field is declared with. */
    protected function getFieldType(Schema $property, bool $required, ?Specification $spec = null): string
    {
        $type = $this->getTypeName($property, $spec);
        if ($required && !$this->getSchema($property)->nullable) {
            return $type;
        }

        return $this->getOptionalKind($property, $spec) === 'nullable' ? 'Nullable!(' . $type . ')' : $type;
    }

    /** Field initializer for a property with a spec default, or '' when none applies. */
    protected function getFieldDefault(Schema $property, bool $required, ?Specification $spec = null): string
    {
        $value = $this->getModelDefault($property, $required);
        if ($value === null || $value === '') {
            return '';
        }

        $type = $this->getTypeName($property, $spec);
        $nullable = $this->getSchema($property)->nullable && $this->getOptionalKind($property, $spec) === 'nullable';

        $literal = match (true) {
            $type === 'string' && \is_string($value) => $this->toStringLiteral($value),
            $type === 'bool' && \is_bool($value) => $value ? 'true' : 'false',
            $type === 'long' && \is_int($value) => (string) $value,
            $type === 'double' && (\is_int($value) || \is_float($value)) => $this->toDoubleLiteral($value),
            \str_starts_with($type, 'enums.') && !\str_ends_with($type, '[]') && \is_string($value) => 'cast(' . $type . ') ' . $this->toStringLiteral($value),
            \str_ends_with($type, '[]') && \is_array($value) && $value === [] => 'null',
            $type === 'string[]' && \is_array($value) && \array_is_list($value) && \array_filter($value, 'is_string') === $value => '[' . \implode(', ', \array_map($this->toStringLiteral(...), $value)) . ']',
            \str_starts_with($type, 'enums.') && \str_ends_with($type, '[]') && \is_array($value) && \array_is_list($value) => '[' . \implode(', ', \array_map(fn($v): string => 'cast(' . \substr($type, 0, -2) . ') ' . $this->toStringLiteral((string) $v), $value)) . ']',
            default => '',
        };

        if ($literal === '' || $literal === 'null') {
            return '';
        }

        return $nullable ? 'Nullable!(' . $type . ')(' . $literal . ')' : $literal;
    }

    protected function toDoubleLiteral(int|float $value): string
    {
        $text = \var_export((float) $value, true);

        return \str_contains($text, '.') || \str_contains($text, 'E') || \str_contains($text, 'e') ? $text : $text . '.0';
    }

    public function toStringLiteral(string $value): string
    {
        $escaped = \preg_replace_callback(
            '/[\\\\"\x00-\x1f\x7f]/',
            static fn(array $match): string => match ($match[0]) {
                '\\' => '\\\\',
                '"' => '\\"',
                "\n" => '\\n',
                "\r" => '\\r',
                "\t" => '\\t',
                default => \sprintf('\\x%02x', \ord($match[0])),
            },
            $value,
        );

        return '"' . $escaped . '"';
    }

    protected function getReturnType(Operation $method, Specification $spec): string
    {
        if ($this->isTextResponse($method, $spec)) {
            return 'string';
        }

        return match ($this->getMethodType($method, $spec)) {
            Language::METHOD_TYPE_WEB_AUTH => 'string',
            Language::METHOD_TYPE_LOCATION => 'ubyte[]',
            default => $this->getResponseReturnType($method),
        };
    }

    protected function getResponseReturnType(Operation $method): string
    {
        $models = \array_values(\array_filter(
            $this->getOperationResponseModels($method),
            static fn(string $model): bool => $model !== 'any',
        ));
        if (\count($models) > 1) {
            return 'JSONValue';
        }
        if ($models !== []) {
            return 'models.' . $this->toTypeName($models[0]);
        }

        foreach ($method->responses as $response) {
            if ($response->content !== []) {
                return 'JSONValue';
            }
        }

        return 'void';
    }

    public function getParamExample(Schema|Parameter $param, string $lang = ''): string
    {
        $type = $this->getSchemaType($param);
        $example = $this->getSchemaExample($param);
        $hasExample = !empty($example) || $example === 0 || $example === false;

        if (!$hasExample) {
            return match ($type) {
                self::TYPE_NUMBER => '0.0',
                self::TYPE_INTEGER => '0',
                self::TYPE_BOOLEAN => 'false',
                self::TYPE_STRING => '""',
                self::TYPE_OBJECT => 'parseJSON("{}")',
                self::TYPE_ARRAY => '[]',
                self::TYPE_FILE => 'InputFile.fromPath("file.png")',
                default => 'JSONValue.init',
            };
        }

        return match ($type) {
            self::TYPE_NUMBER => $this->toDoubleLiteral((float) $example),
            self::TYPE_INTEGER => (string) (int) $example,
            self::TYPE_BOOLEAN => $example ? 'true' : 'false',
            self::TYPE_STRING => $this->toStringLiteral((string) $example),
            self::TYPE_OBJECT => 'parseJSON(' . $this->toStringLiteral(\is_string($example) ? $example : (string) \json_encode($example)) . ')',
            self::TYPE_ARRAY => $this->getArrayExample($param, $example),
            self::TYPE_FILE => 'InputFile.fromPath("file.png")',
            default => 'JSONValue.init',
        };
    }

    protected function getArrayExample(Schema|Parameter $param, mixed $example): string
    {
        if (\is_string($example) && $this->isPermissionString($example)) {
            return $this->getPermissionExample($example);
        }

        $decoded = \is_string($example) ? \json_decode($example, true) : $example;
        if (!\is_array($decoded)) {
            return '[]';
        }

        $items = $this->getArraySchema($param);
        $itemType = $items !== null ? $this->getSchemaType($items) : '';
        $values = \array_map(function (mixed $value) use ($itemType): string {
            return match (true) {
                \is_string($value) => $this->toStringLiteral($value),
                \is_bool($value) => $value ? 'true' : 'false',
                \is_int($value) && $itemType === self::TYPE_NUMBER => $this->toDoubleLiteral($value),
                \is_int($value), \is_float($value) => (string) $value,
                default => 'parseJSON(' . $this->toStringLiteral((string) \json_encode($value)) . ')',
            };
        }, $decoded);

        return '[' . \implode(', ', $values) . ']';
    }

    /** A named argument for a docs example, with enum members spelled out. */
    protected function getArgumentExample(Parameter $param): string
    {
        $name = $this->getParamName($param);
        $schema = $this->getSchema($param);

        if ($this->getSchemaType($param) === self::TYPE_FILE) {
            $value = 'InputFile.fromPath("file.png")';
        } elseif ($this->usesEnumType($param)) {
            $enumSchema = $this->getEnumSchema($param);
            $enumName = $this->toTypeName($this->getSchemaEnumName($param));
            $keys = $this->resolveEnumKeys($param);
            $example = $this->getSchemaExample($param);
            $members = [$example ?? $enumSchema->enum[0] ?? ''];
            if ($schema instanceof ArraySchema) {
                $decoded = \is_string($example) ? \json_decode($example, true) : $example;
                $members = \is_array($decoded) && $decoded !== [] ? $decoded : [$enumSchema->enum[0] ?? ''];
            }
            $variants = [];
            foreach ($members as $member) {
                $index = \array_search($member, $enumSchema->enum, true);
                $key = $index !== false ? ($keys[$index] ?? (string) $enumSchema->enum[$index]) : ($keys[0] ?? '');
                $variants[] = 'enums.' . $enumName . '.' . $this->toEnumMember((string) $key);
            }
            $value = $schema instanceof ArraySchema ? '[' . \implode(', ', $variants) . ']' : ($variants[0] ?? '');
        } else {
            $value = $this->isOpenStringEnum($param) ? $this->getSuggestedEnumExample($param) : $this->getParamExample($param);
        }

        if (!$this->isRequiredParam($param) && $this->getOptionalKind($param, null, true) === 'nullable') {
            $value = $value . '.nullable';
        }

        return $name . ': ' . $value;
    }

    #[Override]
    public function getPermissionExample(string $example): string
    {
        $permissions = [];
        foreach ($this->extractPermissionParts($example) as $permission) {
            $args = [];
            if ($permission['id'] !== null) {
                $args[] = $this->toStringLiteral((string) $permission['id']);
            }
            if ($permission['innerRole'] !== null) {
                $args[] = $this->toStringLiteral((string) $permission['innerRole']);
            }
            $permissions[] = 'Permission.' . $permission['action'] . '(Role.' . $permission['role'] . '(' . \implode(', ', $args) . '))';
        }

        return '[' . \implode(', ', $permissions) . ']';
    }

    /** D enum member: lowerCamelCase, keyword-safe. */
    public function toEnumMember(string $key): string
    {
        $member = \lcfirst($this->toPascalCase($key));
        if ($member === '' || \ctype_digit($member[0])) {
            $member = 'value' . \ucfirst($member);
        }

        return $this->escapeKeyword($member);
    }

    /** Module name for a generated file: snake_case, keyword-safe. */
    public function toModuleName(string $name): string
    {
        $split = (string) \preg_replace(['/([a-z0-9])([A-Z])/', '/([A-Z]+)([A-Z][a-z])/'], '$1_$2', $name);

        return $this->escapeKeyword($this->toSnakeCase($split));
    }

    /** Wrap text as a `///` ddoc comment at the given indent. */
    protected function toDocComment(?string $value, int $indent = 0): string
    {
        $value = \trim((string) $value);
        if ($value === '') {
            return '';
        }

        $pad = \str_repeat(' ', $indent);
        $lines = [];
        foreach (\explode("\n", $value) as $line) {
            $line = \rtrim($line);
            if ($line === '') {
                $lines[] = $pad . '///';
                continue;
            }
            foreach (\explode("\n", \wordwrap($line, 80)) as $wrapped) {
                $lines[] = $pad . '/// ' . $wrapped;
            }
        }

        return \implode("\n", $lines) . "\n";
    }

    #[Override]
    public function getFilters(): array
    {
        return [
            new TwigFilter('dModule', fn(string $value): string => $this->toModuleName($value)),
            new TwigFilter('dTypeName', fn(string $value): string => $this->toTypeName($value)),
            new TwigFilter('dType', fn(Schema|Parameter $value, ?Specification $spec = null): string => $this->getTypeName($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dParamDeclaration', fn(Parameter $value, ?Specification $spec = null): string => $this->getParamDeclaration($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dParamIsSet', fn(Parameter $value, ?Specification $spec = null): string => $this->getParamIsSet($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dParamValue', fn(Parameter $value, ?Specification $spec = null): string => $this->getParamValue($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dPathValue', fn(Parameter $value, ?Specification $spec = null): string => $this->getPathValue($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dParamName', fn(Parameter|string $value): string => $this->getParamName($value)),
            new TwigFilter('dParamRequired', fn(Parameter $value): bool => $this->isRequiredParam($value)),
            new TwigFilter('dFieldName', fn(string $value): string => $this->getFieldName($value)),
            new TwigFilter('dFieldType', fn(Schema $value, bool $required, ?Specification $spec = null): string => $this->getFieldType($value, $required, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dFieldDefault', fn(Schema $value, bool $required, ?Specification $spec = null): string => $this->getFieldDefault($value, $required, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dReturnType', fn(Operation $value, Specification $spec): string => $this->getReturnType($value, $spec), ['is_safe' => ['html']]),
            new TwigFilter('dString', fn(?string $value): string => $this->toStringLiteral($value ?? ''), ['is_safe' => ['html']]),
            new TwigFilter('dEnumMember', fn(string $value): string => $this->toEnumMember($value)),
            new TwigFilter('dDoc', fn(?string $value, int $indent = 0): string => $this->toDocComment($value, $indent), ['is_safe' => ['html']]),
            new TwigFilter('dArgumentExample', fn(Parameter $value): string => $this->getArgumentExample($value), ['is_safe' => ['html']]),
        ];
    }
}
