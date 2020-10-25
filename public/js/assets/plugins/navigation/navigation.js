/*
    селектор корневого блока меню
*/

;navigation = function(navSelector) {
    $(navSelector).addClass('navigation');
    var navMainItems = $(navSelector).children('ul').length > 0 ? $(navSelector).children('ul').children('li') : $(navSelector).children('li'),
        openTimeout;
    $(navMainItems).on('mouseenter mouseleave tap', function(e) {
        var thisMainItem = this, // селектор пункта главного меню
            isActiveMainItem = $(thisMainItem).hasClass('active'), // активен ли текущий пункт
            subItemsBlock = $(thisMainItem).children('div'), // блок подпунктов
            isVisible = $(thisMainItem).children('div').is(':visible'), // открыл ли блок подкатегорий
            type = e.type; // тип взаимодействия
            //mainItemsVisible = 
        
        if(type == 'tap' || type == 'touchstart') {
            if(! isActiveMainItem) {
                $(thisMainItem).addClass('active');
            } else {
                $(thisMainItem).removeClass('active');
            }
        } /*else if(type == 'touchstart') {
            if(isVisible) {
                if($(subItemsBlock).is(':hover') == false) {
                    $(thisMainItem).removeClass('active');
                }
            } else {
                $(thisMainItem).addClass('active');
                $('body').addClass('nav');
            }
            e.preventDefault();
        }*/ else if(type == 'mouseenter') {
            clearTimeout(openTimeout);
            openTimeout = setTimeout(function() {
                if($(thisMainItem).is(':hover')) {
                    $(thisMainItem).addClass('active');
                }
            }, 100);
        } else if(type == 'mouseleave') {
            $(thisMainItem).removeClass('active');
        }
    });
    
    
    
    /*$('body').on('touchstart', function() {
        if($(this).hasClass('nav')) {
            $(navMainItems).removeClass('active');
        }
    });*/
    
};