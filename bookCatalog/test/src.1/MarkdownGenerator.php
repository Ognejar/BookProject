<?php
use Monolog\Logger;

class MarkdownGenerator {
    private $logger;

    public function __construct(Logger $logger) {
        $this->logger = $logger;
    }

    /**
     * Генерирует документацию модуля в формате Markdown.
     *
     * @param string $moduleName Имя модуля.
     * @param array $parsedData Разобранные данные модуля.
     * @return string Markdown-документация.
     */
    public function generateModuleDoc($moduleName, $parsedData) {
        $templatePath = __DIR__ . '/../templates/module.md.template';

        if (!file_exists($templatePath)) {
            $this->logger->error("Шаблон не найден: $templatePath");
            return '';
        }

        $template = file_get_contents($templatePath);

        $moduleDescription = $parsedData['moduleDescription'] ?? '';
        $types = $parsedData['types'] ?? [];
        $inlineComments = $parsedData['inlineComments'] ?? [];
        $tags = $parsedData['tags'] ?? [];

        // Извлечение метаданных
        $authors = $this->extractTagValues($tags, 'author');
        $abstract = $this->extractTagValue($tags, 'abstract') ?: $moduleDescription;
        $created = $this->extractTagValue($tags, 'created');
        $lastmod = $this->extractTagValue($tags, 'lastmod');

        // Генерация секций
        $typesContent = $this->generateTypesSection($types);
        $inlineCommentsContent = $this->generateInlineCommentsSection($inlineComments);

        // Замена Platzhalter
        $replacements = [
            '{{name}}' => $moduleName,
            '{{description}}' => $abstract ?: '',
            '{{authors}}' => $authors ? "**Авторы:** " . implode(", ", $authors) . "\n" : '',
            '{{types}}' => $typesContent,
            '{{inlineComments}}' => $inlineCommentsContent,
            '{{created}}' => $created ?: '',
            '{{lastmod}}' => $lastmod ?: '',
        ];

        return str_replace(array_keys($replacements), array_values($replacements), $template);
    }

    /**
     * Извлекает значение тега из массива тегов.
     *
     * @param array $tags Массив тегов.
     * @param string $tagName Название тега.
     * @return string Значение тега.
     */
    private function extractTagValue($tags, $tagName) {
        if (isset($tags[$tagName])) {
            return trim(implode(' ', $tags[$tagName]));
        }
        return '';
    }

    /**
     * Извлекает значения тега как массив.
     *
     * @param array $tags Массив тегов.
     * @param string $tagName Название тега.
     * @return array Значения тега.
     */
    private function extractTagValues($tags, $tagName) {
        if (isset($tags[$tagName])) {
            return array_map('trim', $tags[$tagName]);
        }
        return [];
    }

    /**
     * Генерирует секцию с типами и классами.
     *
     * @param array $types Список типов.
     * @return string Markdown-содержимое секции.
     */
    private function generateTypesSection($types) {
        if (!is_array($types)) {
            $this->logger->warning("Ожидался массив типов, но получен: " . gettype($types));
            return '**Типы и классы не найдены.**\n';
        }

        $content = '';
        foreach ($types as $type) {
            $content .= "### {$type['name']}\n";
            $content .= "{$type['comment']}\n\n";

            if (!empty($type['methods'])) {
                $content .= $this->generateMethodSection($type['methods']);
            }

            if (!empty($type['properties'])) {
                $filteredProperties = array_filter($type['properties'], function ($property) {
                    return !empty($property['description']);
                });
                if (!empty($filteredProperties)) {
                    $content .= "- **Свойства:**\n";
                    foreach ($filteredProperties as $property) {
                        $content .= sprintf(
                            "  - `%s`: %s - %s\n",
                            $property['name'],
                            $property['type'],
                            $property['description'] ?? 'Нет описания'
                        );
                    }
                    $content .= "\n";
                }
            }
        }
        return $content ?: '**Типы и классы не найдены.**\n';
    }
    /**
     * Генерирует секцию с методами типа или класса.
     *
     * @param array $methods Список методов.
     * @return string Markdown-содержимое секции.
     */
    private function generateMethodSection($methods) {
        $content = '';
        foreach ($methods as $method) {
            $content .= "#### {$method['name']}()\n";
            $content .= "{$method['description']}\n\n";

            // Проверяем параметры
            if (isset($method['params']) && is_array($method['params']) && !empty($method['params'])) {
                $content .= "- **Параметры:**\n";
                foreach ($method['params'] as $param) {
                    if (isset($param['name'], $param['description'])) {
                        $content .= "  - `{$param['name']}`: {$param['description']}\n";
                    } else {
                        $this->logger->warning("Некорректный формат параметра метода: " . print_r($param, true));
                    }
                }
                $content .= "\n";
            }

            // Проверяем возвращаемое значение
            if (!empty($method['returns'])) {
                $content .= "- **Возвращает:** {$method['returns']}\n\n";
            }

            // Проверяем исключения
            if (isset($method['throws']) && is_array($method['throws']) && !empty($method['throws'])) {
                $content .= "- **Может выбросить исключения:**\n";
                foreach ($method['throws'] as $exception) {
                    if (isset($exception['name'], $exception['description'])) {
                        $content .= "  - `{$exception['name']}`: {$exception['description']}\n";
                    } else {
                        $this->logger->warning("Некорректный формат исключения: " . print_r($exception, true));
                    }
                }
                $content .= "\n";
            }
        }
        return $content;
    }

    /**
     * Генерирует секцию с однострочными комментариями.
     *
     * @param array $inlineComments Список однострочных комментариев.
     * @return string Markdown-содержимое секции.
     */
    private function generateInlineCommentsSection($inlineComments) {
        // Проверяем, является ли $inlineComments массивом
        if (!is_array($inlineComments)) {
            $this->logger->warning("Ожидался массив однострочных комментариев, но получен: " . gettype($inlineComments));
            return '**Однострочные комментарии не найдены.**\n';
        }

        $content = '';
        foreach ($inlineComments as $comment) {
            if (isset($comment['name'], $comment['type'], $comment['comment'])) {
                $content .= "- **{$comment['name']}: {$comment['type']}**: {$comment['comment']}\n";
            } else {
                $content .= "- **{$comment['code']}**: {$comment['comment']}\n";
            }
        }
        return $content ?: '**Однострочные комментарии не найдены.**\n';
    }
}