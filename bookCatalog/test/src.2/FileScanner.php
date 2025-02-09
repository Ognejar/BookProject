<?php
namespace MyNamespace;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use RuntimeException;
use SplFileInfo;


class FileScanner {
    /**
     * Рекурсивно сканирует папку и возвращает список Pascal-файлов.
     *
     * @param string $directory Путь к папке.
     * @return array Список файлов с относительными путями.
     * @throws RuntimeException Если директория недоступна.
     */
    public function scanDirectory(string $directory): array {
        // Проверяем, что директория существует и доступна
        if (!is_dir($directory) || !is_readable($directory)) {
            throw new RuntimeException("Директория недоступна или не существует: $directory");
        }

        $files = [];
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($directory, RecursiveDirectoryIterator::SKIP_DOTS),
            RecursiveIteratorIterator::SELF_FIRST
        );

        foreach ($iterator as $file) {
            // Пропускаем скрытые файлы и папки
            if ($this->isHidden($file)) {
                continue;
            }

            // Обрабатываем только файлы с расширением .pas
            if ($file->isFile() && $file->getExtension() === 'pas') {
                $relativePath = $this->getRelativePath($file->getPathname(), $directory);
                $files[] = [
                    'path' => $file->getPathname(),
                    'relativePath' => $relativePath,
                ];
            }
        }

        return $files;
    }

    /**
     * Проверяет, является ли файл или папка скрытыми.
     *
     * @param SplFileInfo $file Файл или папка.
     * @return bool True, если файл или папка скрыты.
     */
    private function isHidden(SplFileInfo $file): bool {
        return str_starts_with($file->getFilename(), '.');
    }

    /**
     * Возвращает относительный путь файла относительно указанной директории.
     *
     * @param string $filePath Абсолютный путь к файлу.
     * @param string $directory Абсолютный путь к директории.
     * @return string Относительный путь.
     */
    private function getRelativePath(string $filePath, string $directory): string {
        $relativePath = substr($filePath, strlen($directory) + 1);
        return str_replace('\\', '/', $relativePath); // Нормализация путей
    }
}