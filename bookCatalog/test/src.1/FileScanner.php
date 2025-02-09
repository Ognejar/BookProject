<?php
class FileScanner {
    /**
     * Рекурсивно сканирует папку и возвращает список Pascal-файлов.
     *
     * @param string $directory Путь к папке.
     * @return array Список файлов с относительными путями.
     */
    public function scanDirectory($directory) {
        $files = [];
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($directory, RecursiveDirectoryIterator::SKIP_DOTS),
            RecursiveIteratorIterator::SELF_FIRST
        );

        foreach ($iterator as $file) {
            if ($file->isFile() && $file->getExtension() === 'pas') {
                $relativePath = substr($file->getPathname(), strlen($directory) + 1);
                $relativePath = str_replace('\\', '/', $relativePath); // Нормализация путей
                $relativePath = mb_convert_encoding($relativePath, 'UTF-8', 'auto'); // Корректная обработка кодировки
                $files[] = [
                    'path' => $file->getPathname(),
                    'relativePath' => $relativePath,
                ];
            }
        }

        return $files;
    }
}