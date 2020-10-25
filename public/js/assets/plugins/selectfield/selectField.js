jQuery(document).ready(function($) {
	
	random = function(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    };
	
	
	$('body').find('[selectfield]').not($('[popup] [selectfield]')).each(function() {
		setSelectField(this);
	});
	
	$(document).on('popup:open', function() {
		$('body').find('.popup').find('[selectfield]').each(function() {
			setSelectField(this, true);
		});
		setSelectFieldMobile();
	});
	
	
	$.fn.selectField = function() {
		setSelectField(this);
		setSelectFieldMobile();
	};
	
	
	
	function setSelectField(thisItem, ispopup) {
		var thisItemId = random(0, 9999),
			selectHtml = '',
			inpName = $(thisItem).attr('name');
		
		
		$(thisItem).wrap('<div class="selectfield__wrapper" id="selectfield'+thisItemId+'"></div>');
		
		selectHtml += '<select name="'+inpName+'_type">';
		selectHtml +=	'<option data-val="phone" value="Телефон">Телефон</option>';
        selectHtml +=	'<option data-val="skype" value="Skype">Skype</option>';
        selectHtml +=	'<option data-val="whatsapp" value="WhatsApp">WhatsApp</option>';
        selectHtml +=	'<option data-val="email" value="E-Mail">E-mail</option>';
		selectHtml += '</select>';
		
		$(thisItem).before(selectHtml);
		
		$(thisItem).val(lscache.get('phone')).mask('+7 (999) 999-99-99', {autoclear: false}).attr({'placeholder': '+7 (___) ___-__-__', 'type': 'tel', 'rules': 'phone'});
		
		if (ispopup && ! /\+\d{1} \(\d{3}\) \d{3}-\d{2}-\d{2}/.test(lscache.get('phone'))) $(thisItem).focus();
		
		//$(thisItem).siblings('select').selectric();
		
		$(thisItem).siblings('select').on('change', function(e) {
            var optionSelectedType = $(this).children('option:selected').data('val');
            
            if(optionSelectedType == 'phone') {
                $(thisItem).unmask().val(lscache.get('phone')).mask('+7 (999) 999-99-99', {autoclear: false}).attr({'placeholder': '+7 (___) ___-__-__', 'type': 'tel', 'rules': 'phone'});
            } else if(optionSelectedType == 'whatsapp') {
                $(thisItem).unmask().val(lscache.get('whatsapp')).mask('+7 (999) 999-99-99', {autoclear: false}).attr({'placeholder': '+7 (___) ___-__-__', 'type': 'tel', 'rules': 'phone'});
            } else if (optionSelectedType == 'skype') {
                $(thisItem).unmask().val(lscache.get('skype')).attr({'placeholder': 'Ваш логин скайп', 'type': 'text', 'rules': 'skype'});
            } else if (optionSelectedType == 'email') {
                $(thisItem).unmask().val(lscache.get('email')).attr({'placeholder': 'Ваш E-mail', 'type': 'email', 'rules': 'email'});
            }
            
            setTimeout(function() {
            	if (optionSelectedType == 'phone' && ! /\+\d{1} \(\d{3}\) \d{3}-\d{2}-\d{2}/.test(lscache.get('phone'))) $(thisItem).focus();
            	else if (optionSelectedType == 'whatsapp' && ! /\+\d{1} \(\d{3}\) \d{3}-\d{2}-\d{2}/.test(lscache.get('whatsapp'))) $(thisItem).focus();
            	else if (optionSelectedType != 'phone' && optionSelectedType != 'whatsapp') {
            		$(thisItem).focus();
            	}
            }, 200);
        });
        
        
        $(thisItem).on('keyup', function() {
        	lscache.set($(thisItem).siblings('select').children('option:selected').data('val'), $(thisItem).val());
        });
        
        
        
	};
	
	
	
	function setSelectFieldMobile() {
		var winW = $(window).width();
		
		$('body').find('[selectfield]').each(function() {
			if ($(this).parent('.selectfield__wrapper').outerWidth() + 80 >= winW) {
				$(this).parent('.selectfield__wrapper').addClass('mobile');
			} else {
				$(this).parent('.selectfield__wrapper').removeClass('mobile');
			}
		});
	};

	
	setSelectFieldMobile();
	
	
	$(window).resize(function() {
		setSelectFieldMobile();
	});
	
	
});