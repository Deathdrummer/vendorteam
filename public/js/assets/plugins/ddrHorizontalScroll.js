$.fn.ddrHorizontalScroll = function(params) {
	let container = this,
		o = $.extend({
			ignoreSelectors: false,
			mouseWheelScrollStep: 30,
			mouseWheel: false
		}, params);
	
	if (o.mouseWheel) {
		$(container).mousewheel(function(e) {
			e.preventDefault();
			$(this).stop(false, true).animate({scrollLeft: ($(this).scrollLeft() + o.mouseWheelScrollStep * -e.deltaY)}, 100);
		});
	}
	
	$(container).mousedown(function(e) {
		var mousemoveStat = true;
		if ((o.ignoreSelectors && $(this).find(o.ignoreSelectors+':hover').length > 0) || $(this).find('input:hover').length > 0) mousemoveStat = false;
		
		$(container).children().css('cursor', 'e-resize');
		var startX = this.scrollLeft + e.pageX;
		$(container).mousemove(function (e) {
			if (mousemoveStat) this.scrollLeft = startX - e.pageX;
			//return false;
		}); 
	});

	$(window).mouseup(function() {
		$(container).children().css('cursor', 'default');
		$(container).off("mousemove");
	});
}	