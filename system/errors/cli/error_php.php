<?php defined('BASEPATH') OR exit('No direct script access allowed'); ?>

Обнаружена ошибка PHP

Строгость:    <?php echo $severity, "\n"; ?>
Сообщение:     <?php echo $message, "\n"; ?>
Имя файла:    <?php echo $filepath, "\n"; ?>
Номер строки: <?php echo $line; ?>

<?php if (defined('SHOW_DEBUG_BACKTRACE') && SHOW_DEBUG_BACKTRACE === TRUE): ?>

Обратный путь:
<?php	foreach (debug_backtrace() as $error): ?>
<?php		if (isset($error['file']) && strpos($error['file'], realpath(BASEPATH)) !== 0): ?>
	File: <?php echo $error['file'], "\n"; ?>
	Line: <?php echo $error['line'], "\n"; ?>
	Function: <?php echo $error['function'], "\n\n"; ?>
<?php		endif ?>
<?php	endforeach ?>

<?php endif ?>
