/*
	Вертикальная прокрутка таблицы сфиксацией шапки и подвала
		- minHeight - минимальная высота контейнера (px vh или %)
		- maxHeight - максимальная высота контейнера (px vh или %)
	Методы:
		- scroll: мягкий скролл. [top, bottom, int]
		- reInit: реинициализация таблицы (перезадаются значения ширины ячеек)
*/
;$.fn.ddrTable = function(params) {
	let table = this,
		ops = $.extend({
			minHeight: '200px',
			maxHeight: '300px'
		}, params);
	
	
	if (table[0].localName != 'table') throw Error('ddrTable ошибка! Необходимо указать таблицу в качестве селектора!');
	
	
	
	let rand = random(0,9999),
		thead = $(table).children('thead')[0].outerHTML,
		tfoot = $(table).children('tfoot').length ? $(table).children('tfoot')[0].outerHTML : false;
	
	$(table).children('thead, tfoot').remove();
	$(table).wrap('<div id="ddrTable'+rand+'"></div>');
	
	let container = $('#ddrTable'+rand);
	
	if (!tfoot) $(container).css('border-bottom', '1px solid #e6e6e6');
	
	$(container).prepend('<table id="ddrTableTop'+rand+'">'+thead+'</table>');
	if (tfoot) $(container).append('<table id="ddrTableBottom'+rand+'">'+tfoot+'</table>');
	$(table).wrap('<div class="scroll_y scroll_y_thin" style="overflow-y:scroll;min-height:'+ops.minHeight+';max-height:'+ops.maxHeight+';" id="scrollTableWrap'+rand+'"></div>');
	
	let tableTopTd = $('#ddrTableTop'+rand).find('tr:first').children('td'),
		tableMainTd = $(table).find('tr:first').children('td'),
		tableBottomTd = tfoot ? $('#ddrTableBottom'+rand).find('tr:first').children('td') : false;
	
	$(tableTopTd).each(function(k, td) {
		if (k + 1 == tableTopTd.length) return true;
		$(tableMainTd).eq(k).css('width', $(td).outerWidth());
		if (tableBottomTd) $(tableBottomTd).eq(k).css('width', $(td).outerWidth());
	});
	
	let resizeTOut;
	$(window).resize(function() {
		clearTimeout(resizeTOut);
		resizeTOut = setTimeout(function() {
			$(tableTopTd).each(function(k, td) {
				if (k + 1 == tableTopTd.length) return true;
				$(tableMainTd).eq(k).css('width', $(td).outerWidth());
				if (tableBottomTd) $(tableBottomTd).eq(k).css('width', $(td).outerWidth());
			});
		}, 3);
	});
	
	return {
		scroll(to, speed) {
			if (to == undefined) {
				console.error('Ошибка ddrTable метод scroll! Не указано направление прокрутки!');
				return false;
			}
			if (to == 'top'){
				$('#scrollTableWrap'+rand).stop().animate({scrollTop: 0}, (speed || 1000), 'easeOutQuint'); // https://easings.net/ru
			} else if (to == 'bottom') {
				let scrHeight = $(table).height(),
					winHeight = $('#scrollTableWrap'+rand)[0].clientHeight;
				$('#scrollTableWrap'+rand).stop().animate({scrollTop: (scrHeight - winHeight)}, (speed || 1000), 'easeOutQuint'); // https://easings.net/ru
			} else if (isInt(to)) {
				$('#scrollTableWrap'+rand).stop().animate({scrollTop: to}, (speed || 1000), 'easeOutQuint'); // https://easings.net/ru
			}
		},
		reInit() {
			tableTopTd = $('#ddrTableTop'+rand).find('tr:first').children('td'),
			tableMainTd = $(table).find('tr:first').children('td'),
			tableBottomTd = tfoot ? $('#ddrTableBottom'+rand).find('tr:first').children('td'): false;
			
			$(tableTopTd).each(function(k, td) {
				if (k + 1 == tableTopTd.length) return true;
				$(tableMainTd).eq(k).css('width', $(td).outerWidth());
				if (tableBottomTd) $(tableBottomTd).eq(k).css('width', $(td).outerWidth());
			});
		}
	};
};