/*
	Вертикальная прокрутка таблицы сфиксацией thead (обернуть таблицу контейнером (например, div) и указать его плагину)
		- высота контейнера (px vh или %)
		- класс для контейнера
		- цвет окантовки для конетйнера
	Методы:
		- reInit: при изменении высоты блока (например, добавление записи в список)
*/
;$.fn.ddrScrollTableY = function(ops) {
	if (this.length == 0) return false;
	let container = this,
		tagName = container[0].localName,
		innerHeight = container[0].scrollHeight,
		thead,
		tfoot,
		tfootPos,
		wrapHeight,
		scrollTop = 0,
		o = $.extend({
			height: '80vh',
			minHeight: '1px',
			cls: false,
			wrapBorderColor: false,
			offset: 0
		}, ops);
	
	if (tagName == 'table') {
		let rand = random(0,9999);
		thead = $(container).children('thead');
		tfoot = $(container).children('tfoot');
		$(container).wrap('<div id="ddrScrollTableY'+rand+'"></div>');
		container = $('#ddrScrollTableY'+rand);
	} else {
		thead = $(container).children('table').children('thead') || false;
		tfoot = $(container).children('table').children('tfoot') || false;
	}
	
	$(container).css('min-height', o.minHeight).css('max-height', o.height).addClass('scroll_y'+(o.cls ? ' '+o.cls : ''));
	
	wrapHeight = $(container).height();
	
	if (o.wrapBorderColor) $(container).css({
		'border-top': '1px solid '+o.wrapBorderColor,
		'border-bottom': '1px solid '+o.wrapBorderColor
	});
	
	$(thead).css({
		'position': 'relative',
		'z-index': 1010
	});
	
	tfootPos = -innerHeight+wrapHeight;
	$(tfoot).css({
		'position': 'relative',
		'z-index': 1010,
		'transform': 'translateY('+(tfootPos+o.offset)+'px)'
	});
	
	$(window).resize(function() {
		wrapHeight = $(container).height();
		scrollTop = $(container).scrollTop();
		tfootPos = -innerHeight+wrapHeight;
		$(tfoot).css({'transform': 'translateY('+(tfootPos+scrollTop+o.offset)+'px)'});
	});
	
	$(container).scroll(function(e) {
		scrollTop = $(this).scrollTop();
		$(thead).css({'transform': 'translateY('+scrollTop+'px)'});
		$(tfoot).css({'transform': 'translateY('+(tfootPos+scrollTop+o.offset)+'px)'});
	});
	
	const obj = {
		reInit: function() {
			innerHeight = container[0].scrollHeight;
			wrapHeight = $(container).height();
			scrollTop = $(container).scrollTop();
			tfootPos = -innerHeight+wrapHeight;
			$(tfoot).css({'transform': 'translateY('+(tfootPos+scrollTop+o.offset)+'px)'});
		}
	};
	
	return obj;
};