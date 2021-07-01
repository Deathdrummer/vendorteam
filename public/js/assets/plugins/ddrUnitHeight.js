/*
	Единая высота для блоков
	Высота берется от самого большого
		- контейнер
		- элементы, .которые нужно уравнять
		- задать минимальную высоту
*/
$.fn.ddrUnitHeight = function(setHeightItem, minHeight) {
	var itemsBlock = this,
		maxHeight = minHeight || 0,
		items = $(itemsBlock).find(setHeightItem);
	
	$(itemsBlock).ready(function() {
		$(items).each(function() {
			var thisHeight = $(this).height();
			if (thisHeight > maxHeight) maxHeight = thisHeight;
		});
		$(items).height(maxHeight);
	});
}