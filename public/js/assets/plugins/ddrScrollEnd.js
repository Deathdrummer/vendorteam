/*
	Событие прокрутки страницы до конца
		- каллбэк
		- таймаут
*/



function ddrScrEnd(selector, callback, timeout) {
	var scrollTOut,
		winH,
		docH,
		scrTop;
	
	function scrollAction() {
		clearTimeout(scrollTOut);
		scrollTOut = setTimeout(function() {
			winH = selector == true ? $(window).height() : $(selector).height(),
			docH = selector == true ? $(document).height() : $(selector).children().height(),
			scrTop = selector == true ? $(document).scrollTop() : $(selector).scrollTop();
			if (winH + scrTop >= docH - 100) {
				if (callback != undefined && typeof callback == 'function') callback();
			}
		}, (timeout || 200));
	};
	
	
	if ('ontouchstart' in window) {
		if (selector == true) {
			$(window).scroll(function() {
				scrollAction();
			});
		} else {
			$(selector).scroll(function() {
				scrollAction();
			});
		}
	} else {
		if (selector == true) {
			$(window).mousewheel(function(e) {
				if (e.deltaY == -1) scrollAction();
			});
			
			$(window).on('keyup', function(e) {
				if ([40, 34].indexOf(e.keyCode) != -1) scrollAction();
			});
		} else {
			$(selector).mousewheel(function(e) {
				if (e.deltaY == -1) scrollAction();
			});
			
			$(selector).on('keyup', function(e) {
				if ([40, 34].indexOf(e.keyCode) != -1) scrollAction();
			});
		}	
	}	
};


ddrScrollEnd = function(callback, timeout) {
	ddrScrEnd(true, callback, timeout)
};


$.fn.ddrScrollEnd = function(callback, timeout) {
	ddrScrEnd(this, callback, timeout)
};