$(document).ready(function() {
    
    
    /* ----------------- Мобильное выезжающее меню ----------------- */
    var snapper = new Snap({
        element: document.getElementById('mobileNavBlock'), // ID меню
        dragger: document.getElementById('mobileNavButton'), // кнопка меню (не понимаю, для чего)
        tapToClose: false, // закроется при клике 
        addBodyClasses: false, // не заню
        hyperextensible: false, // ограничение связано с maxPosition и minPosition
        maxPosition: 290, // 
        minPosition: 0, // 
        disable: 'right', // запрет на перемещение в сторону
        flickThreshold: 10, // кол-во писселей, перетащив через которые меню само закроется
    });

    
    $('#mobileNavButton').on(tapEvent, function(e) {
        e.preventDefault();
        snapper.open('left');
    });


    snapper.on('open', function() {
        $('.mobilenavwrap').stop().fadeIn(100);
        disableScroll();
    });

    snapper.on('end', function() {
        snapper.on('animated', function() {
            if($('#mobileNavBlock').position().left <= -260) {
                $('.mobilenavwrap').stop().fadeOut(50, function() {
                    enableScroll();
                });                
            }   
        });
    });

    var scrollTOut;
    $('.mobilenavwrap, #mobileNavButtonClose, [data-scroll-nav]').on(tapEvent, function() { 
        clearTimeout(scrollTOut); 
        snapper.close();
        scrollTOut = setTimeout(function() {
            enableScroll();
            $('.mobilenavwrap').stop().fadeOut(50);
        }, 100);
    });
});