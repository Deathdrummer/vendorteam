<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>

<div style="border:2px solid #ff0000;border-radius: 5px;padding:10px;margin:20px;background: #fee;">

<h4>Было обнаружено неперехваченное исключение</h4>

<p>Тип: <?php echo get_class($exception); ?></p>
<p>Сообщение: <?php echo $message; ?></p>
<p>Имя файла: <?php echo $exception->getFile(); ?></p>
<p>Номер строки: <?php echo $exception->getLine(); ?></p>

<?php if (defined('SHOW_DEBUG_BACKTRACE') && SHOW_DEBUG_BACKTRACE === TRUE): ?>

	<p>Обратный путь:</p>
	<?php foreach ($exception->getTrace() as $error): ?>

		<?php if (isset($error['file']) && strpos($error['file'], realpath(BASEPATH)) !== 0): ?>

			<p style="margin-left:10px">
			Файл: <?php echo $error['file']; ?><br />
			Строка: <?php echo $error['line']; ?><br />
			Функция: <?php echo $error['function']; ?>
			</p>
		<?php endif ?>

	<?php endforeach ?>

<?php endif ?>

</div>