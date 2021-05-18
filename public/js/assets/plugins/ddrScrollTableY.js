/*
	Вертикальная прокрутка таблицы сфиксацией thead (обернуть таблицу контейнером и указать его плагину)
		- высота контейнера (px vh или %)
		
*/
;$.fn.ddrScrollTableY = function(height) {
	let container = this,
		thead = $(container).find('thead'),
		h = height || '90vh',
		scrollTop = 0;
	
	$(container).css('max-height', h);
	$(container).addClass('scroll_y');
	
	$(thead).css({
		'position': 'relative',
		'z-index': 1010
	});
	
	$(container).scroll(function(e) {
		scrollTop = $(this).scrollTop();
		$(thead).css({'transform': 'translateY('+scrollTop+'px)'});
	});
};