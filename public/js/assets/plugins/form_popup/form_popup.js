jQuery(document).ready(function($) {
	
	var closeTimeOut,
		tapEvent = ('ontouchstart' in window) ? 'tap' : 'click';
	
	
	
	
	$('body').on(tapEvent, 'div[popup] button, div[form] button, div[popup] [submit], div[form] [submit]', function(e) {
		e.preventDefault();
		clearTimeout(closeTimeOut);
		
		var thisButton = this,
			thisParentBlock = $(thisButton).closest('div[popup], div[form]'),
			type = $(thisParentBlock).attr('popup') !== undefined ? 'popup' : 'form',
			
			formAction 			= $(thisParentBlock).data('action') || 'form_order.php',
			formTitle 			= $(thisParentBlock).find('title').text() || 'Заголовок формы',
			formWidth 			= $(thisParentBlock).data('width') || 500,
			formSuccessHtml 	= $(thisParentBlock).find('success').get(0).outerHTML,
			formSuccessTitle	= $(thisParentBlock).find('success').attr('notitle') != undefined,
			formCancel 			= $(thisParentBlock).data('cancel') || false,
			formClass 			= $(thisParentBlock).data('class') || false,
			formCloseTime 		= $(thisParentBlock).data('closetime') || 10,
			metrika 			= $(thisParentBlock).data('metrika') ? $(thisParentBlock).data('metrika').split(':') : false,
			wrapToClose			= $(thisParentBlock).attr('wraptoclose') == undefined || false,
			callback			= $(thisParentBlock).data('callback') || false;
		
		
		if (type == 'form') { // -------------------------------------------------------------------------------------- обычная, невсплывающая форма
			
			$.post(formAction, $(thisParentBlock).find('popupform').formSerialize(true), function(errors) {	
				if (errors.length == 0) {
					
					if (callback) window[callback]($(thisParentBlock).find('popupform').formSerialize());
					
					popUp({
					    width: formWidth,
					    height: false,
					    html: formSuccessHtml,
					    winClass: formClass,
					    closeButton: formCancel,
					}, function(formWin) {
						$(thisParentBlock).find('popupform').find('[name]:not(.selectfield__wrapper [name]):not([type=hidden])').val('');
						closeTimeOut = setTimeout(function() {
							formWin.close();
						}, formCloseTime * 1000);
					});
					
				} else {
					console.log(errors);
					$.each(errors, function(field, errors) {
						$(thisParentBlock).find('[name='+field+']').addClass('error').append('sdvsdvsdvs');
					});
				}
			}, 'json').fail(function(e) {
				console.log(e.responseText);
			});
			
			
		} else if (type == 'popup') { // ------------------------------------------------------------------------------------------ всплывающая форма
			
			var formId = $(thisParentBlock).attr('id'),
				formActionButtonTitle = $(thisParentBlock).data('button') || 'Отправить',		
				formHtml = $(thisParentBlock).find('popupform').get(0).outerHTML,
				formActionButtonId = 'popupFormButton'+formId,
				popupContainerId = 'formContainer'+Math.floor(Math.random() * (999 - 0 + 1)) + 0;
			
			
			popUp({
				title: formTitle,
			    width: formWidth,
			    height: false,
			    html: '<div id="'+popupContainerId+'">'+formHtml+'</div>',
			    wrapToClose: wrapToClose,
			    winClass: formClass,
			    buttons: [{
			    	title: formActionButtonTitle,
			    	id: formActionButtonId,
			    	metrikaId: metrika[0],
			    	metrikaTargetId: metrika[1]
			    }],
			    closeButton: formCancel,
			}, function(formWin) {
				formWin.correctPosition(100);
				
				$('#'+popupContainerId).find('[name=phone], .phone, [type="tel"]').mask('+7 (999) 999-99-99', {autoclear: false}).attr({'placeholder': '+7 (___) ___-__-__', 'type': 'tel'});
				
				$('#'+formActionButtonId).on(tapEvent, function() {
					formWin.wait();
					
					$.post(formAction, $('#'+popupContainerId+' popupform').formSerialize(true), function(errors) {	
						
						formWin.wait(false);
						
						if (! errors) {
							if (callback) window[callback]($('#'+popupContainerId+' popupform').formSerialize());
							formWin.setData(formSuccessHtml, false);
							if (formSuccessTitle) {
								formWin.deleteTitle();
							}
							closeTimeOut = setTimeout(function() {
								formWin.close();
							}, formCloseTime * 1000);
						} else {
							$.each(errors, function(field, errors) {
								$('#'+popupContainerId+' popupform').find('[name='+field+']').addClass('error');
							});
						}
					}, 'json').fail(function(e) {
						formWin.wait(false);
						console.log(e.responseText);
					});
				});
			});
		}
		
	});
	
	
	$(document).on('popup:close', function() {
		clearTimeout(closeTimeOut);
	});
	
	
	
});