;getRating = function(settings) {
    var ops = $.extend({
        selector: false, // контейнер
        scale: 5, // шкала (бальность)
        readOnly: false, // только для просмотра
        type: false, // тип рейтинга (поле)
        labelSize: 12, // размер лэйбла
        countMarks: false, // указать количество уже выставленных оценок
        size: 20, // размер иконок рейтинга
        theme: 'orange', // тема
        icon: 'star', // иконка без fa fa-
        mark: false, // оценка
        showMarkOnLabel: false, // показывать оценку на лэйбле
        showNums: false, // номера под звездами
        onClick: false, // событие при клике
    }, settings);
    
    
    $(ops.selector).addClass('rating-block').css('padding-bottom', (ops.size / 12)+'px');
    
    
    
    var labels = {
        'reviews': 'Отзывов',
    };
    
    
    
    
    
    var html = '<div class="stars-block noselect">';
    for(x = ops.scale; x > 0; x--) {
        html += '<span class="stars-block__star'+(ops.readOnly ? ' read-only' : '')+' '+ops.theme+' fa fa-'+ops.icon+''+(ops.mark && ops.mark == x ? ' active' : '')+'" data-mark="'+x+'" style="font-size:'+ops.size+'px;">';
        if (ops.showNums) html += '<p class="stars-block__star-num" style="font-size:0.45em;">'+x+'</p>';
        html += '</span>';
    }
    html += '<div class="stars-block">';
    
    $(ops.selector).append(html);
    $(ops.selector).append('<span class="rating-block__label noselect" style="font-size:'+ops.labelSize+'px;">'+labels[ops.type] + (ops.countMarks ? ' ('+ops.countMarks+')' : '')+'</span>');
    
    
    // рейтинг
    if(! ops.readOnly) {
        $(ops.selector).children('.stars-block').hover(function() {
            $(this).find('.stars-block__star.active').addClass('hover');
        }, function() {
            $(this).find('.stars-block__star.active').removeClass('hover');
        });
        
        $(ops.selector).on('click', '.stars-block__star', function() {
            var thisMark = $(this).data('mark');
            if(ops.onClick) ops.onClick(thisMark);
            $(this).parent('.stars-block').find('.stars-block__star.active').removeClass('active hover');
            $(this).addClass('active hover');
            
            if(ops.showMarkOnLabel) $(ops.selector).find('.rating-block__label span').text('('+thisMark+')'); 
        });
    }
    
    return thisRating = {
        refresh: function() {
            $(ops.selector).find('.stars-block__star.active').removeClass('active hover');
        }
    }
    
};