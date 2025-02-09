<?php
// Определение имени выходного файла
$outputFile = __DIR__ . '/struktura.txt';

// Очистка или создание выходного файла
file_put_contents($outputFile, '');

// Функция для обработки директории
function processDir($dir, $indentLevel, $outputFile) {
    // Генерация строки отступа
    $indent = str_repeat('  ', $indentLevel) . ($indentLevel > 0 ? '├── ' : '');

    // Открываем директорию
    $items = scandir($dir);
    foreach ($items as $item) {
        // Пропускаем специальные директории . и ..
        if ($item === '.' || $item === '..') {
            continue;
        }

        // Пропускаем папки, начинающиеся с точки (например, .git, .idea)
        if (substr($item, 0, 1) === '.') {
            continue;
        }

        // Полный путь к элементу
        $path = $dir . DIRECTORY_SEPARATOR . $item;

        // Если это директория
        if (is_dir($path)) {
            // Пропускаем специальные директории
            if (strtolower($item) === '__recovery' || strtolower($item) === '__history') {
                continue;
            }

            // Записываем имя директории в файл
            file_put_contents($outputFile, $indent . $item . PHP_EOL, FILE_APPEND);

            // Рекурсивно обрабатываем поддиректорию
            processDir($path, $indentLevel + 1, $outputFile);
        } else {
            // Пропускаем файлы с расширением .dcu
            if (strtolower(pathinfo($item, PATHINFO_EXTENSION)) === 'dcu') {
                continue;
            }

            // Записываем имя файла в файл
            file_put_contents($outputFile, $indent . $item . PHP_EOL, FILE_APPEND);
        }
    }
}

// Обработка текущей директории
processDir(__DIR__, 0, $outputFile);

echo "Дерево директорий успешно сохранено в файл 1.txt" . PHP_EOL;