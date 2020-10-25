$.fn.ddrScrollX = function(scrollStep, scrollSpeed, enableMouseScroll) {
	var block = this,
		scrollStep = scrollStep || 50,
		scrollSpeed = scrollSpeed || 100;
	
	if (enableMouseScroll != undefined && enableMouseScroll == true) {
		$(block).mousewheel(function(e) {
			e.preventDefault();
			$(this).stop(false, true).animate({scrollLeft: ($(this).scrollLeft() + scrollStep * -e.deltaY)}, scrollSpeed);
		});
	}
	
	$(block).mousedown(function(e) {
		$(block).children().css('cursor', 'e-resize');
		var startX = this.scrollLeft + e.pageX;
		$(block).mousemove(function (e) {
			this.scrollLeft = startX - e.pageX;
			return false;
		});
	});
	
	$(window).mouseup(function () {
		$(block).children().css('cursor', 'default');
		$(block).off("mousemove");
	});
};