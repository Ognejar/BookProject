<?php
use Monolog\Logger;

class Processor {
    private $fileScanner;
    private $parser;
    private $markdownGenerator;
    private $outputDir;
    private $logger;

    public function __construct($outputDir, Logger $logger) {
        $this->fileScanner = new FileScanner();
        $this->parser = new Parser($logger);
        $this->markdownGenerator = new MarkdownGenerator($logger);
        $this->outputDir = $outputDir;
        $this->logger = $logger;
    }

    /**
     * Обрабатывает указанную директорию, парсит файлы и генерирует документацию.
     *
     * @param string $directory Путь к директории с Pascal-файлами.
     */
    public function processDirectory($directory) {
        try {
            $this->logger->info("Начинаем обработку директории: $directory");

            // Сканирование директории
            $files = $this->fileScanner->scanDirectory($directory);
            if (empty($files)) {
                $this->logger->warning("Директория пуста или не содержит Pascal-файлов: $directory");
                echo "Предупреждение: Директория пуста или не содержит Pascal-файлов.\n";
                return;
            }

            foreach ($files as $fileInfo) {
                $filePath = $fileInfo['path'];
                $relativePath = $fileInfo['relativePath'];
                $moduleName = pathinfo($filePath, PATHINFO_FILENAME);

                $this->logger->info("Обрабатываем файл: $relativePath");

                // Парсинг файла
                $parsedData = $this->parser->parseFile($filePath);

                // Генерация Markdown-документации
                $markdown = $this->markdownGenerator->generateModuleDoc($moduleName, $parsedData);

                // Сохранение документации в файл
                $outputPath = $this->getOutputFilePath($relativePath, $moduleName);
                file_put_contents($outputPath, $markdown);
                $this->logger->info("Сгенерирован Markdown-файл: $outputPath");
            }

            $this->logger->info("Обработка директории завершена.");
            echo "Документация успешно сгенерирована!\n";
        } catch (Exception $e) {
            $errorMessage = "Ошибка при обработке директории: " . $e->getMessage();
            $this->logger->error($errorMessage);
            echo "Ошибка: $errorMessage\n";
        }
    }

    /**
     * Возвращает путь для сохранения Markdown-файла.
     *
     * @param string $relativePath Относительный путь файла.
     * @param string $moduleName Имя модуля.
     * @return string Полный путь к выходному файлу.
     */
    private function getOutputFilePath($relativePath, $moduleName) {
        $outputPath = $this->outputDir . '/' . dirname($relativePath) . '/' . $moduleName . '.md';
        if (!is_dir(dirname($outputPath))) {
            mkdir(dirname($outputPath), 0777, true);
        }
        return $outputPath;
    }
}