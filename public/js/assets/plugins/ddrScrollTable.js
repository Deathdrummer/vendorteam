/*
	Горизонтальная прокрутка таблицы мышью
		- шаг прокрутки
		- скорость прокрутки
		- горизонтальная прокрутка колесом мыши
		- элемент для фиксации (по-умолчанию thead)
		- элементы при наведении на которые, прокрутки не будет
*/
$.fn.ddrScrollTable = function(scrollStep, scrollSpeed, enableMouseScroll, fixElement, ignore) {
	var block = this,
		fixElem = $(block).find(fixElement || 'thead'),
		scrollStep = scrollStep || 50,
		scrollSpeed = scrollSpeed || 100;
	
	if (!$(block).length || !$(fixElem).length) return false;
	
	
	if (enableMouseScroll != undefined && enableMouseScroll == true) {
		$(block).mousewheel(function(e) {
			e.preventDefault();
			$(this).stop(false, true).animate({scrollLeft: ($(this).scrollLeft() + scrollStep * -e.deltaY)}, scrollSpeed);
		});
	}
	
	$(block).scroll(function(e) {
		var scrTop = $(this).scrollTop();
		$(fixElem).css({
			'transform': 'translateY('+scrTop+'px)',
			'position': 'relative',
			'z-index': 99999
		});
	});
	
	$(block).mousedown(function(e) {
		var mousemoveStat = true;
		if ((ignore && $(this).find(ignore+':hover').length > 0) || $(this).find('input:hover').length > 0) mousemoveStat = false;
		
		$(block).children().css('cursor', 'e-resize');
		var startX = this.scrollLeft + e.pageX;
		$(block).mousemove(function (e) {
			if (mousemoveStat) this.scrollLeft = startX - e.pageX;
			//return false;
		});
	});
	
	$(window).mouseup(function() {
		$(block).children().css('cursor', 'default');
		$(block).off("mousemove");
	});
};