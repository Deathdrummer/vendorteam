<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>

<div style="border:2px solid #ff0000;border-radius: 5px;padding:10px;margin:20px;background: #fee;">

<h4>Обнаружена ошибка PHP</h4>

<p class="fz14px mb5px">Строгость: <?php echo $severity; ?></p>
<p class="fz14px mb5px">Сообщение:  <?php echo $message; ?></p>
<p class="fz14px mb5px">Имя файла: <?php echo $filepath; ?></p>
<p class="fz14px mb5px">Номер строки: <?php echo $line; ?></p>

<?php if (defined('SHOW_DEBUG_BACKTRACE') && SHOW_DEBUG_BACKTRACE === TRUE): ?>

	<p class="fz14px mb5px">Обратный путь:</p>
	<?php foreach (debug_backtrace() as $error): ?>

		<?php if (isset($error['file']) && strpos($error['file'], realpath(BASEPATH)) !== 0): ?>
			
			<ul class="fz14px pl10px mb15px p10px">
				<li><span class="d-inline-block w80px">Файл:</span> <strong><?php echo $error['file'] ?></strong></li>
				<li><span class="d-inline-block w80px">Строка:</span> <strong><?php echo $error['line'] ?></strong></li>
				<li><span class="d-inline-block w80px">Функция:</span> <strong><?php echo $error['function'] ?></strong></li>
			</ul>

		<?php endif ?>

	<?php endforeach ?>

<?php endif ?>

</div>