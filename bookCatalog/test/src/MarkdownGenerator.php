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
        $globalVariables = $parsedData['globalVariables'] ?? [];
        $types = $parsedData['types'] ?? [];

        // Извлечение метаданных
        $tags = $this->extractTags($moduleDescription);
        $authors = $tags['author'] ?? [];
        $abstract = $tags['abstract'][0] ?? $moduleDescription;
        $created = $tags['created'][0] ?? '';
        $lastmod = $tags['lastmod'][0] ?? '';

        // Генерация секций
        $globalVariablesContent = $this->generateGlobalVariablesSection($globalVariables);
        $typesContent = $this->generateTypesSection($types);

        // Замена Platzhalter
        $replacements = [
            '{{name}}' => $moduleName,
            '{{description}}' => $abstract ?: '',
            '{{authors}}' => $authors ? "**Авторы:** " . implode(", ", $authors) . "\n" : '',
            '{{created}}' => $created ? "**Дата создания:** $created\n" : '',
            '{{lastmod}}' => $lastmod ? "**Последнее изменение:** $lastmod\n" : '',
            '{{globalVariables}}' => $globalVariablesContent,
            '{{types}}' => $typesContent,
        ];

        return str_replace(array_keys($replacements), array_values($replacements), $template);
    }

    /**
     * Извлекает специальные теги из описания модуля.
     *
     * @param string $description Описание модуля.
     * @return array Массив тегов.
     */
    private function extractTags($description) {
        $tags = [];
        preg_match_all('/@(\w+)\s*\((.*)\)/', $description, $matches, PREG_SET_ORDER);
        foreach ($matches as $match) {
            $tagName = strtolower(trim($match[1]));
            $tagValue = trim($match[2]);
            $tags[$tagName][] = $tagValue;
        }
        return $tags;
    }

    /**
     * Генерирует секцию с глобальными переменными.
     *
     * @param array $globalVariables Список глобальных переменных.
     * @return string Markdown-содержимое секции.
     */
    private function generateGlobalVariablesSection($globalVariables) {
        if (empty($globalVariables)) {
            return '**Глобальные переменные не найдены.**\n';
        }

        $content = "## Глобальные переменные\n";
        foreach ($globalVariables as $variable) {
            $content .= "- **{$variable['name']}: {$variable['type']}**: {$variable['comment']}\n";
        }
        return $content . "\n";
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

            foreach ($type['sections'] as $sectionName => $sectionItems) {
                if (!empty($sectionItems)) {
                    $content .= "#### Секция: $sectionName\n";
                    foreach ($sectionItems as $item) {
                        if ($item['type'] === 'function') {
                            $content .= "- **{$item['name']}()**: {$item['comment']}\n";
                        } else {
                            $content .= "- **{$item['name']}: {$item['type']}**: {$item['comment']}\n";
                        }
                    }
                    $content .= "\n";
                }
            }
        }

        return $content ?: '**Типы и классы не найдены.**\n';
    }
}