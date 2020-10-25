;$.fn.imgLoaded = function(func) {
	var i = new Image(),
		imageSrc = $(this).attr('src');
	i.onload = function() {
		if (typeof func == 'function') func();
	}
	i.src = imageSrc;
};