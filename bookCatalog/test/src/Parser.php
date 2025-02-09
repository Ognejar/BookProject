<?php
use Monolog\Logger;

class Parser {
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

        foreach ($lines as $lineNumber => $line) {
            $trimmedLine = trim($line);

            if (empty($trimmedLine)) {
                continue;
            }

            // Конец секции модуля
            if (str_starts_with($trimmedLine, 'implementation')) {
                $inModuleSection = false;
                $currentComment = ''; // Сбрасываем текущий комментарий
                continue;
            }

            // Обработка многострочных комментариев до implementation
            if ($inModuleSection && str_starts_with($trimmedLine, '{')) {
                $currentComment .= str_replace(['{', '}'], '', $trimmedLine) . ' ';
                continue;
            }

            // Сохраняем описание модуля
            if ($inModuleSection && strpos($trimmedLine, 'unit') === 0) {
                $moduleDescription = trim($currentComment);
                $currentComment = '';
                $this->logger->debug("Найдено описание модуля: $moduleDescription");
            }

            // Глобальные переменные
            if ($inModuleSection && preg_match('/^\s*(\w+)\s*:\s*(\w+);/', $trimmedLine, $varMatch)) {
                $varName = trim($varMatch[1]);
                $varType = trim($varMatch[2]);
                if (!empty($currentComment)) {
                    $globalVariables[] = [
                        'name' => $varName,
                        'type' => $varType,
                        'comment' => trim($currentComment),
                    ];
                    $currentComment = '';
                }
            }

            // Обработка типов/классов
            if (preg_match('/^\s*\w+\s*=\s*class/i', $trimmedLine)) {
                if (!empty($currentComment)) {
                    $typeName = $this->extractTypeName($trimmedLine);
                    $types[$typeName] = [
                        'name' => $typeName,
                        'comment' => trim($currentComment),
                        'sections' => ['default' => []],
                    ];
                    $this->logger->debug("Найден тип/класс: $typeName -> $currentComment");
                    $currentType = $typeName;
                    $currentComment = '';
                }
            }

            // Обработка секций внутри класса
            if (isset($currentType) && preg_match('/^\s*(private|public|published)\s*;?/', $trimmedLine, $sectionMatch)) {
                $sectionName = strtolower(trim($sectionMatch[1]));
                if (!isset($types[$currentType]['sections'][$sectionName])) {
                    $types[$currentType]['sections'][$sectionName] = [];
                }
            }
            echo "\nОбработка секций внутри класса\n";
print_r($types);
            // Обработка полей/методов внутри секций
            if (isset($currentType)) {
                // Поля
                if (preg_match('/^\s*(\w+)\s*:\s*(\w+);/', $trimmedLine, $propertyMatch)) {
                    $propertyName = trim($propertyMatch[1]);
                    $propertyType = trim($propertyMatch[2]);

                    // Объединяем многострочные и однострочные комментарии
                    $propertyComment = trim($currentComment);
                    if (preg_match('/\/\/\s*(.*)$/', $trimmedLine, $inlineCommentMatch)) {
                        $propertyComment .= ' ' . str_replace(['<', '>'], '', trim($inlineCommentMatch[1]));
                    }

                    $types[$currentType]['sections'][$sectionName][] = [
                        'name' => $propertyName,
                        'type' => $propertyType,
                        'comment' => $propertyComment,
                    ];
                    $currentComment = '';
                }

                // Методы
                if (preg_match('/^\s*function\s+(\w+)\s*\(.*\)/', $trimmedLine, $methodMatch)) {
                    $methodName = trim($methodMatch[1]);

                    // Объединяем многострочные и однострочные комментарии
                    $methodComment = trim($currentComment);
                    if (preg_match('/\/\/\s*(.*)$/', $trimmedLine, $inlineCommentMatch)) {
                        $methodComment .= ' ' . str_replace(['<', '>'], '', trim($inlineCommentMatch[1]));
                    }

                    $types[$currentType]['sections'][$sectionName][] = [
                        'name' => $methodName,
                        'type' => 'function',
                        'comment' => $methodComment,
                    ];
                    $currentComment = '';
                }
            }

            // Накопление многострочного комментария
            if (str_starts_with($trimmedLine, '{') || strpos($trimmedLine, '}') !== false) {
                $currentComment .= str_replace(['{', '}'], '', $trimmedLine) . ' ';
            }
        }

        $this->logger->info("Парсинг файла завершён: $filePath");

        return [
            'moduleDescription' => $moduleDescription,
            'globalVariables' => $globalVariables,
            'types' => array_values($types),
        ];
    }

    /**
     * Извлекает имя типа или класса из строки.
     *
     * @param string $line Строка с определением типа или класса.
     * @return string Имя типа или класса.
     */
    private function extractTypeName($line): string
    {
        if (preg_match('/^\s*(\w+)\s*=/i', $line, $matches)) {
            return trim($matches[1]);
        }
        return 'UnknownType';
    }
}