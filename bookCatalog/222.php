<?php

function scanDirectory($directory) {
    $files = [];
    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($directory));
    foreach ($iterator as $file) {
        if ($file->isFile() && $file->getExtension() === 'pas') {
            $files[] = $file->getPathname();
        }
    }
    return $files;
}

function extractComments($fileContent) {
    $comments = [];
    $lines = explode("\n", $fileContent);
    $inCommentBlock = false;
    $currentComment = '';
    $currentLineComment = '';
    $currentCodeLine = '';

    foreach ($lines as $line) {
        $trimmedLine = trim($line);

        // Обработка блочных комментариев
        if (preg_match('/^\{\s*$/', $trimmedLine)) {
            $inCommentBlock = true;
            $currentComment = trim($line, " {}");
        } elseif ($inCommentBlock) {
            if (preg_match('/^\}\s*$/', $trimmedLine)) {
                $inCommentBlock = false;
                $comments[] = ['type' => 'block', 'comment' => $currentComment, 'code' => $currentCodeLine];
                $currentComment = '';
                $currentCodeLine = '';
            } else {
                $currentComment .= "\n" . trim($line, " {}");
            }
        }
        // Обработка строчных комментариев
        elseif (preg_match('/^\/\/\s*<.*$/', $trimmedLine) || preg_match('/^\/\/\s*.*$/', $trimmedLine)) {
            if ($currentCodeLine !== '') {
                $comments[] = ['type' => 'line', 'comment' => trim($line, " /"), 'code' => $currentCodeLine];
                $currentCodeLine = '';
            } else {
                $currentLineComment = trim($line, " /");
                $comments[] = ['type' => 'line', 'comment' => $currentLineComment, 'code' => $currentCodeLine];
            }
        } else {
            $currentCodeLine = $line;
        }
    }

    return $comments;
}

function processComments($comments) {
    $processedComments = [];

    foreach ($comments as $comment) {
        $lines = explode("\n", $comment['comment']);
        $description = array_shift($lines);
        $tags = [];

        foreach ($lines as $line) {
            if (preg_match('/@(\w+)\((.+?)\)/', $line, $matches)) {
                $tags[$matches[1]][] = $matches[2];
            }
        }

        $processedComments[] = [
            'type' => $comment['type'],
            'description' => $description,
            'tags' => $tags,
            'code' => $comment['code']
        ];
    }

    return $processedComments;
}

function generateMarkdown($comments, $moduleName) {
    $mdContent = "# $moduleName\n\n";

    foreach ($comments as $comment) {
        $mdContent .= "## " . $comment['description'] . "\n\n";

        foreach ($comment['tags'] as $tag => $values) {
            $mdContent .= "### @$tag\n\n";
            foreach ($values as $value) {
                $mdContent .= "- $value\n";
            }
            $mdContent .= "\n";
        }

        if ($comment['code'] !== '') {
            $mdContent .= "```pascal\n" . \$comment['code'] . "\n```\n\n";
        }
    }

    return $mdContent;
}

function generateIndex($modules) {
    $indexContent = "# Индекс\n\n";

    foreach ($modules as $moduleName => $comments) {
        $indexContent .= "- [$moduleName](#$moduleName)\n";
    }

    return $indexContent;
}

function main($directory) {
    $files = scanDirectory($directory);
    $modules = [];

    foreach ($files as $file) {
        $fileContent = file_get_contents($file);
        $comments = extractComments($fileContent);
        $processedComments = processComments($comments);
        $moduleName = pathinfo($file, PATHINFO_FILENAME);
        $modules[$moduleName] = $processedComments;
    }

    $indexContent = generateIndex($modules);
    file_put_contents('index.md', $indexContent);

    foreach ($modules as $moduleName => $comments) {
        $mdContent = generateMarkdown($comments, $moduleName);
        file_put_contents($moduleName . '.md', $mdContent);
    }
}

// Задайте путь к подпапке
$directory = __DIR__ . '/app';
main($directory);

?>
