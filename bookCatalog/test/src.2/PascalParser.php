<?php
namespace MyNamespace;

use Monolog\Logger;

class PascalParser {
    private $logger;

    public function __construct(Logger $logger) {
        $this->logger = $logger;
    }

    /**
     * Парсит файл и возвращает структурированные данные.
     *
     * @param string $filePath Путь к файлу.
     * @return array Разобранные данные.
     */
    public function parseFile($filePath) {
        if (!file_exists($filePath)) {
            $this->logger->error("Файл не найден: $filePath");
            return [];
        }

        $this->logger->info("Начинаем парсинг файла: $filePath");

        $lines = file($filePath, FILE_IGNORE_NEW_LINES);
        $moduleDescription = '';
        $globalVariables = [];
        $types = [];
        $currentComment = '';
        $inModuleSection = true;
        $currentType = null;
        $sectionName = 'default';
        $moduleMetadata = []; // Метаданные модуля (директивы JavaDoc)

        foreach ($lines as $lineNumber => $line) {
            $trimmedLine = trim($line);

            if (empty($trimmedLine)) {
                continue;
            }

            // Обработка комментариев
            if ($this->isComment($trimmedLine)) {
                $currentComment .= $this->extractComment($trimmedLine) . ' ';
                continue;
            }

            // Конец секции модуля
            if (str_starts_with($trimmedLine, 'implementation')) {
                $inModuleSection = false;
                $currentComment = ''; // Сбрасываем текущий комментарий
                continue;
            }

            // Сохраняем описание модуля и метаданные
            if ($inModuleSection && strpos($trimmedLine, 'unit') === 0) {
                $moduleDescription = trim($currentComment);
                $moduleMetadata = $this->parseJavaDocDirectives($moduleDescription); // Парсим директивы
                $currentComment = '';
                $this->logger->debug("Найдено описание модуля: $moduleDescription");
            }

            // Глобальные переменные
            if ($inModuleSection && preg_match('/^\s*(\w+)\s*:\s*(\w+);/', $trimmedLine, $varMatch)) {
                $globalVariables[] = $this->createVariableEntry($varMatch, $currentComment);
                $currentComment = '';
            }

            // Обработка типов/классов
            if (preg_match('/^\s*(\w+)\s*=\s*(class|interface|record)\s*(?:\((\w+)\))?/i', $trimmedLine, $typeMatch)) {
                $typeName = trim($typeMatch[1]);
                $parentClass = isset($typeMatch[3]) ? trim($typeMatch[3]) : null; // Родительский класс
                $types[$typeName] = $this->createTypeEntry($typeName, $currentComment, $parentClass);
                $this->logger->debug("Найден тип/класс: $typeName -> $currentComment" . ($parentClass ? " (наследует $parentClass)" : ""));
                $currentType = $typeName;
                $currentComment = '';
            }

            // Обработка секций внутри класса
            if (isset($currentType) && preg_match('/^\s*(private|public|published|protected)\s*;?/', $trimmedLine, $sectionMatch)) {
                $sectionName = strtolower(trim($sectionMatch[1]));
                $types[$currentType]['sections'][$sectionName] = $types[$currentType]['sections'][$sectionName] ?? [];
            }

            // Обработка полей/методов внутри секций
            if (isset($currentType)) {
                $this->processClassMembers($trimmedLine, $types[$currentType]['sections'][$sectionName], $currentComment);
                $currentComment = '';
            }
        }

        $this->logger->info("Парсинг файла завершён: $filePath");

        return [
            'moduleDescription' => $moduleDescription,
            'moduleMetadata' => $moduleMetadata, // Метаданные модуля
            'globalVariables' => $globalVariables,
            'types' => array_values($types),
        ];
    }

    /**
     * Проверяет, является ли строка комментарием.
     *
     * @param string $line Строка для проверки.
     * @return bool True, если это комментарий.
     */
    private function isComment(string $line): bool {
        return str_starts_with($line, '{') || str_starts_with($line, '//');
    }

    /**
     * Извлекает текст комментария.
     *
     * @param string $line Строка с комментарием.
     * @return string Текст комментария.
     */
    private function extractComment(string $line): string {
        if (str_starts_with($line, '{')) {
            return trim(str_replace(['{', '}'], '', $line));
        }
        if (str_starts_with($line, '//')) {
            return trim(substr($line, 2));
        }
        return '';
    }

    /**
     * Парсит JavaDoc-подобные директивы из комментария.
     *
     * @param string $comment Комментарий с директивами.
     * @return array Массив с метаданными.
     */
    private function parseJavaDocDirectives(string $comment): array {
        $metadata = [];
        $lines = explode("\n", $comment);

        foreach ($lines as $line) {
            if (preg_match('/@(\w+)(?:\(([^)]+)\))?\s*(.*)/', $line, $matches)) {
                $directive = strtolower($matches[1]);
                $value = !empty($matches[2]) ? $matches[2] : trim($matches[3]);

                switch ($directive) {
                    case 'author':
                        $metadata['author'] = $value;
                        break;
                    case 'abstract':
                        $metadata['abstract'] = $value;
                        break;
                    case 'version':
                        $metadata['version'] = $value;
                        break;
                    case 'date':
                        $metadata['date'] = $value;
                        break;
                    case 'copyright':
                        $metadata['copyright'] = $value;
                        break;
                    case 'license':
                        $metadata['license'] = $value;
                        break;
                    case 'created':
                        $metadata['created'] = $value;
                        break;
                    case 'lastmod':
                        $metadata['lastmod'] = $value;
                        break;
                }
            }
        }

        return $metadata;
    }

    /**
     * Создает запись для глобальной переменной.
     *
     * @param array $varMatch Результат совпадения регулярного выражения.
     * @param string $comment Комментарий.
     * @return array Запись переменной.
     */
    private function createVariableEntry(array $varMatch, string $comment): array {
        return [
            'name' => trim($varMatch[1]),
            'type' => trim($varMatch[2]),
            'comment' => trim($comment),
        ];
    }

    /**
     * Создает запись для типа/класса.
     *
     * @param string $typeName Имя типа/класса.
     * @param string $comment Комментарий.
     * @param string|null $parentClass Родительский класс (если есть).
     * @return array Запись типа/класса.
     */
    private function createTypeEntry(string $typeName, string $comment, ?string $parentClass = null): array {
        return [
            'name' => $typeName,
            'comment' => trim($comment),
            'parentClass' => $parentClass,
            'sections' => ['default' => []],
        ];
    }

    /**
     * Обрабатывает поля и методы внутри секций класса.
     *
     * @param string $line Строка для обработки.
     * @param array &$section Секция класса.
     * @param string &$comment Текущий комментарий.
     */
    private function processClassMembers(string $line, array &$section, string &$comment) {
        // Поля
        if (preg_match('/^\s*(\w+)\s*:\s*(\w+);/', $line, $propertyMatch)) {
            $section[] = [
                'name' => trim($propertyMatch[1]),
                'type' => trim($propertyMatch[2]),
                'comment' => $this->mergeComments($comment, $line),
            ];
        }

        // Методы
        if (preg_match('/^\s*(function|procedure)\s+(\w+)\s*\(.*\)/', $line, $methodMatch)) {
            $section[] = [
                'name' => trim($methodMatch[2]),
                'type' => trim($methodMatch[1]),
                'comment' => $this->mergeComments($comment, $line),
            ];
        }
    }

    /**
     * Объединяет многострочные и однострочные комментарии.
     *
     * @param string $comment Многострочный комментарий.
     * @param string $line Строка с возможным однострочным комментарием.
     * @return string Объединенный комментарий.
     */
    private function mergeComments(string $comment, string $line): string {
        if (preg_match('/\/\/\s*(.*)$/', $line, $inlineCommentMatch)) {
            $comment .= ' ' . trim($inlineCommentMatch[1]);
        }
        return trim($comment);
    }
}