;$.fn.questions = function(path, finalHtml, width, hash, callback) {
    var clickedSelector = this,
        html = '',
        finalTitle = 'Для Вас идет расчёт...',
        questions = [],
        answers = {},
        timeout,
        changeTime = 200,
        hTOut,
        countQuestions,
        counter = new Counter();
    
    
    $.getJSON(path, function(data) {
        questions = data;
        countQuestions = questions.length;
        
        html += '<div class="questions">';
        html += '   <div>';
        html +=         '<div class="questions__answers">';
        html +=             setQuestionContent(questions[0]);
        html +=         '</div>';
        html +=         '<div class="questions__progress noselect">';
        html +=             '<div class="questions__stroke"><div><p>0%</p></div></div>';
        html +=             '<span class="step prev disabled" data-type="prev" data-response="0"><i class="fa fa-angle-left"></i> назад</span>';
        html +=             '<span class="step next" data-type="next" data-response="0">Пропустить <i class="fa fa-angle-right"></i></span>';
        html +=         '</div>';
        html +=     '<div>';
        html += '</div>';
        
        
        
        $(clickedSelector).prop('disabled', false);
        
        /* Открытие окна диалога, если указан хэштег */
        if (hash != undefined && location.hash == hash) openDialog();
        
        /* Открытие окна диалога */
        $(clickedSelector).on('click', openDialog);
    });
    
    
    
    
    
    
    function openDialog() {
        popUp({
            title: questions[0]['question'],
            titlePos: 'center',
            width: width,
            html: html,
            wrapToClose: true,
        }, function(questionsWin) {
            var i = counter(0);
            questionsWin.correctPosition();
            
            $('.questions').on('click', '.step:not(.disabled)', function() {
                var type = $(this).data('type'),
                    response;
                
                if ($(this).data('response') != undefined) {
                    response = $(this).data('response');
                } else if ($('.questions').find('.step_field').length > 0) {
                    response = $('.questions').find('.step_field').val();
                } else if ($('.questions').find('.step_check').length > 0) {
                    response = [];
                    $('.questions').find('.step_check:checked').each(function() {
                        response.push($(this).data('response'));
                    });
                }
                    
                
                if (type == 'prev' && i > 0) {
                    i = counter(i - 1);
                    setProgress(i);
                    setStep(questionsWin, i);
                } 
                
                if ((type == 'next' || type == 'check') && (i + 1) < countQuestions) {
                    i = counter();
                    setProgress(i);
                    setStep(questionsWin, i, response);
                } else if ((type == 'next' || type == 'check') && (i + 1) == countQuestions) {
                    i = counter();
                    setProgress(i);
                    setFinalStep(questionsWin ,i, response);
                }
                
                
                if (i == 0) {
                    $('.questions').find('.prev').addClass('disabled');
                } else if (i == countQuestions) {
                    $('.questions').find('.next').addClass('disabled');
                } else if (i > 0 && i < countQuestions) {
                    $('.questions').find('.prev').removeClass('disabled');
                }
                
            });
        });
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /* Шаг */
    function setStep(questionsWin, i, response) {
        if (response != undefined) answers[i] = response;
        
        questionsWin.setTitle(questions[i]['question']);
        
        var answersHtml = setQuestionContent(questions[i]);
        
        $('.questions').find('.questions__answers').stop().fadeOut(changeTime, function() {
            $('.questions').find('.questions__answers').html(answersHtml).stop().fadeIn(changeTime);
        });
    }
    
    
    
    
    
    /* Итог */
    function setFinalStep(questionsWin, i, response) {
        answers[i] = response;
        
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            $('.questions').addClass('hidden');
            
            clearTimeout(hTOut);
            hTOut = setTimeout(function() {
                questionsWin.setData(finalHtml);
                questionsWin.setTitle(finalTitle);
                questionsWin.correctPosition();
                
                $('.questions').removeClass('hidden');
                
                if (typeof callback == 'function') callback(answers, questionsWin);
            }, changeTime);
        }, (changeTime * 2));
        
    }
    
    
    
    /* Прогрессбар */
    function setProgress(i) {
        var percent = 100 / countQuestions * i;
        $('.questions').find('.questions__stroke').children('div').width(percent+'%');
        $('.questions').find('.questions__stroke').find('p').text(Math.floor(percent)+'%');
    }
    
    
    
    
    
    
    
    
    function setQuestionContent(question) {
        var html = '';
        
        if (question.type == 'buttons') {
            $.each(question.answers, function(k, answer) {
                html += '<div class="questions__answer"><button class="step" data-type="check" data-response="'+(k+1)+'">'+answer+'</button></div>';
            });
        } else if (question.type == 'field') {
            html += '<div class="questions__answer field"><input type="text" class="step_field" placeholder="'+question.placeholder+'" /></div>';
            html += '<div class="questions__answer field"><button class="step" data-type="check">'+question.button+'</button></div>';
        } else if (question.type == 'multicheck') {
            $.each(question.answers, function(k, answer) {
                html += '<div class="questions__answer multicheck">';
                html +=     '<input class="step_check" data-response="'+(k+1)+'" id="'+(k+1)+'" type="checkbox" /><label for="'+(k+1)+'">'+answer+'</label>';
                html += '</div>';
            });
            html += '<br /><div class="questions__answer multicheck"><button class="step" data-type="check">'+question.button+'</button></div>';
        }
        
        return html;
    }
    
    
    
    
    
    
    
};