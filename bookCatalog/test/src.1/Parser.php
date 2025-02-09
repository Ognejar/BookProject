<?php
use Monolog\Logger;

class Parser {
    private $logger;

    public function __construct(Logger $logger) {
        $this->logger = $logger;
    }

    /**
     * Парсит файл и извлекает описание модуля, типы/классы, методы, свойства и однострочные комментарии.
     *
     * @param string $filePath Путь к файлу.
     * @return array Массив данных: описание модуля, типы/классы, методы, свойства, однострочные комментарии.
     */
    public function parseFile($filePath) {
        if (!file_exists($filePath)) {
            $this->logger->error("Файл не найден: $filePath");
            return [];
        }

        $this->logger->info("Начинаем парсинг файла: $filePath");

        $lines = file($filePath, FILE_IGNORE_NEW_LINES);
        $moduleDescription = '';
        $currentComment = '';
        $inModuleDescription = true;
        $types = [];
        $inlineComments = [];
        $tags = [];
        $currentType = null;

        foreach ($lines as $lineNumber => $line) {
            $trimmedLine = trim($line);

            if (empty($trimmedLine)) {
                continue;
            }

            // Обработка многострочных комментариев перед модулем
            if ($inModuleDescription && strpos($trimmedLine, '{*') === 0) {
                $currentComment .= str_replace(['{*', '*}'], '', $trimmedLine) . ' ';
                continue;
            }

            if ($inModuleDescription && strpos($trimmedLine, 'unit') === 0) {
                $moduleDescription = trim($currentComment);
                $inModuleDescription = false;
                $currentComment = '';
                $this->logger->debug("Найдено описание модуля: $moduleDescription");
                $this->parseTags($moduleDescription, $tags);
            }

            // Обработка однострочных комментариев
            if (preg_match('/^(.*?)\/\/(.*)$/', $trimmedLine, $matches)) {
                $codePart = trim($matches[1]);
                $commentPart = trim($matches[2]);

                // Удаляем лишние символы из комментария
                $commentPart = str_replace(['<', '>'], '', $commentPart);

                if (!empty($codePart) && !empty($commentPart)) {
                    $inlineComments[] = ['code' => $codePart, 'comment' => $commentPart];
                } elseif (empty($codePart) && !empty($commentPart)) {
                    $currentComment .= $commentPart . ' ';
                }
            }

            // Обработка определения типа или класса
            if (strpos($trimmedLine, 'type') === 0 || preg_match('/^\s*\w+\s*=\s*class/i', $trimmedLine)) {
                if (!empty($currentComment)) {
                    $typeName = $this->extractTypeName($trimmedLine);
                    $types[$typeName] = [
                        'name' => $typeName,
                        'comment' => trim($currentComment),
                        'methods' => [],
                        'properties' => [],
                    ];
                    $this->parseTags($currentComment, $types[$typeName]['tags'] ?? []);
                    $this->logger->debug("Найден тип/класс: $typeName -> $currentComment");
                    $currentType = $typeName;
                    $currentComment = '';
                }
            }

            // Обработка свойств внутри класса
            if ($currentType !== null) {
                if (preg_match('/^\s*(\w+)\s*:\s*(\w+);/', $trimmedLine, $propertyMatch)) {
                    $propertyName = trim($propertyMatch[1]);
                    $propertyType = trim($propertyMatch[2]);
                    if (!empty($currentComment)) {
                        $types[$currentType]['properties'][] = [
                            'name' => $propertyName,
                            'type' => $propertyType,
                            'description' => trim($currentComment),
                        ];
                        $currentComment = '';
                    }
                }

                // Обработка методов внутри класса
                if (preg_match('/^\s*function\s+(\w+)\s*\(.*\)/', $trimmedLine, $methodMatch)) {
                    $methodName = trim($methodMatch[1]);
                    $types[$currentType]['methods'][] = [
                        'name' => $methodName,
                        'description' => '',
                        'params' => [],
                        'returns' => '',
                    ];
                }
            }

            // Накопление многострочного комментария перед типом/классом
            if (strpos($trimmedLine, '{') === 0 || strpos($trimmedLine, '}') !== false) {
                $currentComment .= str_replace(['{', '}'], '', $trimmedLine) . ' ';
            }
        }

        $this->logger->info("Парсинг файла завершён: $filePath");

        return [
            'moduleDescription' => $moduleDescription,
            'types' => array_values($types),
            'inlineComments' => $inlineComments,
            'tags' => $tags,
        ];
    }

    /**
     * Извлекает имя типа или класса из строки.
     *
     * @param string $line Строка с определением типа или класса.
     * @return string Имя типа или класса.
     */
    private function extractTypeName($line) {
        if (preg_match('/^\s*(\w+)\s*=/i', $line, $matches)) {
            return trim($matches[1]);
        }
        return 'UnknownType';
    }

    /**
     * Извлекает специальные теги из комментария.
     *
     * @param string $comment Комментарий.
     * @return array Массив тегов.
     */
    private function parseTags($comment) {
        $tags = [];
        preg_match_all('/@(\w+)\s*\((.*)\)/', $comment, $matches, PREG_SET_ORDER);
        foreach ($matches as $match) {
            $tagName = strtolower(trim($match[1]));
            $tagValue = trim($match[2]);
            $tags[$tagName][] = $tagValue;
        }
        return $tags;
    }
}