/* прокрутка страницы по клику на пункты меню 
    для работы необходим плагин scrollstop.js
    
    для пунктов меню добавляется data-scroll-nav
    для блоков добавляется data-scroll-block с таким же значением, как у data-scroll-nav
*/
;$(document).ready(function() {
    
    var points = [],
        getPoints,
        scrollTop,
        resizeTimeOut;
    
    
    if ($('body').find('[data-scroll-block]').length == 0) return false;
    
    
    getPoints = function () {
        points = []; var blockPos;
        $('body').find('[data-scroll-block]').each(function() {
            blockPos = $('[data-scroll-nav='+$(this).data('scroll-block')+']').data('scroll-pos') != undefined ? parseInt($('[data-scroll-nav='+$(this).data('scroll-block')+']').data('scroll-pos')) : 0;
            points.push({
                'block': $(this).data('scroll-block'),
                'pos': $(this).offset().top + blockPos
            });
        });
    };
    
    
    
    
    
    // переиндексация позиций при скролле и изменении ширины окна
    $(window).on('scrollstart resize', function(e) {
        clearTimeout(resizeTimeOut);
        if (e.type == 'resize') {
            resizeTimeOut = setTimeout(function() {
                getPoints();
            }, 200);
        } else {
            getPoints();
        }
    });
    
    
    
    setTimeout(function() {
        getPoints();
        scrollTop = $(window).scrollTop() + 100;
        $.each(points, function(k, item) {
            if ((k + 1) < points.length && (scrollTop >= item.pos && scrollTop < points[k+1]['pos'])) {
                setCurrentBlock(item.block);
            } else if (k + 1 == points.length && scrollTop >= points[points.length - 1]['pos']) {
                setCurrentBlock(points[points.length - 1]['block']);
            }
        });
    }, 100);
    
    
        
    
    $(window).on("scrollstop", {latency: 100}, function() {
        scrollTop = $(window).scrollTop() + 100;
        $.each(points, function(k, item) {
            if ((k + 1) < points.length && (scrollTop >= item.pos && scrollTop < points[k+1]['pos'])) {
                setCurrentBlock(item.block);
            } else if (k + 1 == points.length && scrollTop >= points[points.length - 1]['pos']) {
                setCurrentBlock(points[points.length - 1]['block']);
            }
        });
    });
    
    
    var scrollNavHash, locHash, scrollHash;
    function setCurrentBlock(blockName) {
        $('[data-scroll-nav]').removeClass('active');
        $('[data-scroll-nav = '+blockName+']').addClass('active');
        
        scrollNavHash = $('[data-scroll-nav = '+blockName+']').data('scroll-hash'),
        locHash = location.hash,
        scrollHash = (scrollNavHash != '' && scrollNavHash != '#') ? '#'+scrollNavHash : '';
        if (locHash != scrollHash) history.replaceState({}, 'scrollNavHash', location.origin+location.pathname+location.search+scrollHash);
    }
    
    
    
    var clickScrollStat = false;
    function scrollTo(blockName, animSpeed) {
        var offsTop = $('[data-scroll-block='+blockName+']').offset().top;
        clickScrollStat = true;
        
        $('body').off('mousewheel');
        $('body').on('mousewheel', function() {
            $('html, body').stop();
        });
        
        if(offsTop != $(window).scrollTop()) {
            $('html, body').stop().animate({scrollTop: offsTop}, animSpeed, 'easeInOutQuart', function() {
                $('body').off('mousewheel');
                clickScrollStat = false;
            });
        } else $('body').off('mousewheel');
    }
    
    
    
    
    $('body').find('[data-scroll-nav]').on('tap', function(e) {
        e.preventDefault();
        var thisBlock = this;
        scrollTo($(thisBlock).data('scroll-nav'), 600);
    });
    
    
});