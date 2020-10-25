// Действие при прокрутке в заданной области
$.fn.scrollBlockArea = function(s, c) {
	
	var blockTop = parseInt($(settings.selector).offset().top),
		blockBottom = parseInt(blockTop + $('#tariffs').height()),
		specScrollTop = 0,
		specWinTimeout,
		isOpenedSpec = false,
		waitTime = 30, // время ожидания перед открытием
		stillPos = false; // окрывать окно, только есть позиция все еще находится на позиции блока
	
	//lscache.remove('setSpec');
	
	
	// раскомментировать, если нужно, чтобы появление было только, если скролл в пределах указанной секции
	(getPagePos = function() {
		//clearTimeout(specWinTimeout);
		specScrollTop = $(this).scrollTop();
		if (specScrollTop >= blockTop && specScrollTop <= blockBottom) {
			if (lscache.get('setSpec') === null) {
				if (isOpenedSpec == false) {
					specWinTimeout = setTimeout(function() {
						if (stillPos) {
							specScrollTop = $(this).scrollTop();
							if (specScrollTop >= blockTop && specScrollTop <= blockBottom) {
								setAreaAction();
								isOpenedSpec = true;
							} else {
								clearTimeout(specWinTimeout);
							}
						} else {
							setAreaAction();
							isOpenedSpec = true;
						}
					}, (waitTime * 1000));
				}
			}
		}
	})();
	
	
	$(window).on('scrollstop', function() {
		getPagePos();
	});
	
	
	// Выполнить
	function setAreaAction() {
		// lscache.set('setSpec', 1, 1440);
	}
	
};