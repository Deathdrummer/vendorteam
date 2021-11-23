jQuery(document).ready(function($) {
	
	/* ----------------- FIXes ----------------- */
	$(document).on('focus gesturestart', function(e) {
		e.preventDefault();
	});
	
	/* под вопросом
	document.addEventListener('gesturestart', function (e) {
		e.preventDefault();
	}); */
	
	
	/*$('#mainVide').vide({
		mp4: 'assets/video/ocean.mp4',
		poster: false
	});
	*/
	
	
	
	$('body').on('focus', 'input.error, textarea.error, select.error, .field, .textarea, .select, .file, .ddrselect, .popup__field, .popup__textarea, .popup__select, .popup__file', function() {
		$(this).removeClass('error');
	});
	
	$('body').find('[phonemask], [type="tel"]').each(function() {
		var placeholder = $(this).attr('placeholder');
		$(this).mask('+7 (999) 999-99-99', {autoclear: false}).attr({'placeholder': placeholder, 'type': 'tel'});
	});
	
	
	$('body').find('[phone]').each(function() {
		$(this).attr('href', 'tel:'+$(this).text().trim().replace(/(\+?\d{1}) (\()?(\d{3})(\))? (\d{3})(-)?(\d{2})-(\d{2})/, '+7$3$5$7$8'));
	});
	
	$('body').find('[whatsapp]').each(function() {
		var thisMess = $(this).data('message'),
			thisNumber = $(this).text().trim().replace(/(\+?\d{1}) (\()?(\d{3})(\))? (\d{3})(-)?(\d{2})-(\d{2})/, '+7$3$5$7$8');
		$(this).attr('href', 'whatsapp://send?phone='+thisNumber+'&abid='+thisNumber+'&text='+thisMess);
	});
	
	$('body').find('[email]').each(function() {
		$(this).attr('href', 'mailto:'+$(this).text().trim());
	});
	
	
	//--------------------------------------------- Submit формы только при наличии аттрибута action
	$('body').on('submit', 'form:not([action])', function(e) {
		e.preventDefault();
		return false;
	});
	
	
	//--------------------------------------------- Запретить autocomplete
	$('body').on('focus', 'input[type="text"], input[type="password"], input[type="number"], input[type="email"], input[type="phone"]', function() {
		$(this).removeAttrib('readonly');
	});
	$('body').on('blur', 'input[type="text"], input[type="password"], input[type="number"], input[type="email"], input[type="phone"]', function() {
		$(this).setAttrib('readonly');
	});
	
	
	
	$('body').on('change', 'input[type="checkbox"]', function() {
		if ($(this)[0].hasAttribute('checked')) {
			$(this).prop('checked', false);
			$(this)[0].removeAttribute('checked');
		} else {
			$(this).prop('checked', true);
			$(this)[0].setAttribute('checked', '');
		} 
	});
	
	
	
	
	//--------------------------------------------- Вверх страницы
	var scrTop;
	scrTop = $(window).scrollTop();
	if (scrTop > $(window).height() * 2) {
		$('[scrolltop]').addClass('visible');
	} else {
		$('[scrolltop]').removeClass('visible');
	}
	
	$(window).on('scroll', function() {
		scrTop = $(this).scrollTop();
		if (scrTop > $(window).height() * 2) {
			$('[scrolltop]').addClass('visible');
		} else {
			$('[scrolltop]').removeClass('visible hover');
		}
	});
	
	$('[scrolltop]').on('click', function(e) {
		e.preventDefault();
		$('html, body').animate({scrollTop: 0}, 800, 'easeInOutQuint');
	});
	
	$('[scrolltop]').on('tap click mouseenter', function() {
		$(this).addClass('hover');
	});
	
	$('[scrolltop]').on('mouseleave', function() {
		$(this).removeClass('hover');
	});
	
	
	
	
	
	// Скопировать в буфер
	$('body').on(tapEvent, '[copytoclipboard]', function() {
		let str = $(this).attr('copytoclipboard');
		str = str.trim();
		if (str == '') {
			notify('Нечего копировать!', 'error');
		} else {
			copyStringToClipboard(str);
			notify('Скопировано');
		}
    });
	
	
	

	/* --- Параллакс --- */
	$('body').find('[parallax]').each(function() {
		var thisParallaxData = $(this).attr('parallax').split('|');
		$(this).parallax({
			imageSrc: thisParallaxData[0],
			speed: parseFloat(thisParallaxData[1])
		});
    });
    
    
    
    
    
    
    // -------------------------------------------------------------------- Табы
	$('body').on(tapEvent, '.tabstitles li', function() {
		var thisItem = this,
			noroute = $(thisItem).attr('noroute') || false,
			hashData = location.hash.substr(1, location.hash.length).split('.'),
			thisId = $(thisItem).attr('id'),
			section = hashData[0],
			thisTabsTitles = $(thisItem).closest('.tabstitles'),
			thisTabsContent = $(thisTabsTitles).siblings('.tabscontent');
		
		$(thisItem).removeClass('error');
		
		if (hashData[2] == undefined) {
			$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
				$(this).children('li').removeClass('active');
				$(this).children('li:first').addClass('active');
				
				$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
				$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
			});
		}
		
		$(thisTabsTitles).children('li').removeClass('active');
		$(thisItem).addClass('active');
		
		if ($(thisTabsTitles).hasClass('sub') == false) {
			if (!noroute) location.hash = section+'.'+thisId;
		} else {
			if (!hashData[1]) hashData[1] = $(thisItem).closest('#'+section).find('.tabstitles:not(.sub)').children(':first').attr('id');
			if (!noroute) location.hash = section+'.'+hashData[1]+'.'+thisId;
		}
		
		if ($(thisTabsContent).children('[tabid="'+thisId+'"]').hasClass('visible') == false) {
			$(thisTabsContent).children('[tabid]').removeClass('visible');
			$(thisTabsContent).children('[tabid="'+thisId+'"]').addClass('visible');
		}
		
		$(document).trigger('changetabs', [thisItem, $(thisTabsContent).children('[tabid="'+thisId+'"]')]);
	});
    
    
    
    
    
    
    
    // -------------------------------------------------------------------- Выделить все\снять выделение
    // 
    /*
    	если к checkbutton добавить еще атрибут ddrcheckall - то можно задавать начальное состояние 
    	К главному селектору добавляется атрибут checkbutton с названием атрибута чеков и начальное состояние через |
    	К иконке внутри главного селектора добавляется атрибут cls с классами выделено все|не выделено ничего
    */
	$('body').on(tapEvent, '[checkbutton]', function() {
		let checkSelector = this,
			cls = $(checkSelector).find('i').attr('cls').split('|'),
			checkCls = cls[0] || 'fa fa-check-square-o',
			invertCls = cls[1] || 'fa fa-square-o',
			ch = $(checkSelector).attr('checkbutton').split('|'),
			checkName = ch[0],
			state = ch[1] || 0,
			checkItems = $('body').find('input[type="checkbox"]['+checkName+']');
		
		if ($(checkSelector).attr('ddrcheckall') == undefined) $(checkSelector).setAttrib('ddrcheckall', state);
		checkUncheck();
		
		function checkUncheck() {
			let stat = $(checkSelector).attr('ddrcheckall') == 1 ? 1 : 0;
			if (!stat) {
				$(checkItems).each(function() {
					$(this).setAttrib('checked');
				});
				$(checkSelector).find('i').removeClass(invertCls).addClass(checkCls);
			} else {
				$(checkItems).each(function() {
					$(this).removeAttrib('checked');
				});
				$(checkSelector).find('i').removeClass(checkCls).addClass(invertCls);
			}
			
			$(checkSelector).setAttrib('ddrcheckall', stat == 1 ? 0 : 1);
		}
	});
    
    
    
    
    
    
    
    
    
    
    
   
    
	
	
});