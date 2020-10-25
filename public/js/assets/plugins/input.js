;$.fn.animInput = function(settings) {
    
    var ops = $.extend({
        placeholder: 'Не задано', // текст подсказки
        index: '70%', // степень уменьшения текста при фокусе
        left: 10, // отступ слева у подсказки
        color: '#a2a2a2', // цвет текста подсказки
        colorFocused: '#555', // цвет текста подсказки при фокусе
        transition: '0.2', // скорость анимации
        conditions: [] // содержание поля для возвращения подсказки
    }, settings);
    
    
    
    var thisInput = this,
        inpHeight = $(thisInput).outerHeight(),
        inpHeightFocused = inpHeight / (100 / (parseInt(ops.index) - 20)),
        fontSize = parseInt($(thisInput).css('font-size')),
        fontSizeFocused = fontSize / (100 / parseInt(ops.index));
    
    
    
    $(thisInput).wrap('<div class="animinpit"></div>');
    $('.animinpit').css({'position': 'relative', 'display': 'inline-block'});
    $('.animinpit').append('<span class="animinpit__placeholder">'+ops.placeholder+'</span>');
    
    
    $('.animinpit__placeholder').css({
        'position': 'absolute',
        'left': 0,
        'top': 0,
        'pointer-events': 'none',
        'height': inpHeight+'px',
        'line-height': inpHeight+'px',
        'left': ops.left+'px',
        'color': ops.color,
        'transition': 'all '+ops.transition+'s'
    });
    
    
    $(thisInput).on('focus', function() {
        $('.animinpit__placeholder').css({
            'height': inpHeightFocused+'px',
            'line-height': inpHeightFocused+'px',
            'font-size': fontSizeFocused+'px',
            'top': -inpHeightFocused+'px',
            'left': 0,
            'color': ops.colorFocused
        });
    });
    
    $(thisInput).on('blur', function() {
        if ($(thisInput).val() == '' || $.inArray($(thisInput).val(), ops.conditions) !== -1) {
            $('.animinpit__placeholder').css({
                'height': inpHeight+'px',
                'line-height': inpHeight+'px',
                'font-size': fontSize+'px',
                'top': 0,
                'left': ops.left+'px',
                'color': ops.color
            });
        }
    });
    
    
};