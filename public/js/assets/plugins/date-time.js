//----------------------------------------------  функции работы с датой и временем



// вернуть метку времени, округленную до начала дня (порядок аргументов не важен)
// - метка времени (с миллисекундами или без)
// - маска [d,m,y]:[значение]. Пример: m:5 (+ 5 месяцев)
// - s: вернуть с миллисекундами или без
getTimePoint = function() {
    var args = arguments.length > 0 ? arguments : false,
        date = new Date(),
        mask = false,
        jsFormat = 1;
    
    for (var i = 0; i < args.length; i++) {
        if (/^[0-9]+$/.test(args[i])) {
            date.setTime((args[i].toString().length == 10) ? (args[i] * 1000) : args[i]);
        }
        
        if (/:/.test(args[i])) {
            mask = args[i].split(':');
            mask[1] = parseInt(mask[1]);
        }
        
        if (/^s$/.test(args[i])) {
            jsFormat = 1000;
        }
        
    }
    
    var setYear = (mask && mask[0] == 'y') ? date.getFullYear() + mask[1] : date.getFullYear(),
        setMonth = (mask  && mask[0] == 'm') ? date.getMonth() + mask[1] : date.getMonth(),
        setDay = (mask && mask[0] == 'd') ? date.getDate() + mask[1] : date.getDate(),
        returnDate = new Date(setYear, setMonth, setDay, 0, 0);
    
    return {
        y: returnDate.getFullYear(),
        m: returnDate.getMonth() + 1,
        d: returnDate.getDate(),
        t: returnDate.getTime() / jsFormat,
    };
};


    
getTimePeriod = function(secondsPeriod) {
    var hours = minutes = seconds = '';
    hours = Math.floor(secondsPeriod / (60 * 60));
    minutes = Math.floor((secondsPeriod % (60 * 60)) / 60);
    seconds = (secondsPeriod % 60)+ 'сек ';
    if(hours > 0) hours = hours+'ч '; else hours = '';
    if(minutes > 0) minutes = minutes+'мин '; else minutes = '';
    return hours + minutes + seconds;
};






getDateFromUnix = function(unixTime, returnTime) {
    var monthNames = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    var date = new Date(unixTime * 1000);
    var year = month = day = hours = minutes = seconds = 0;
    
    year    = date.getFullYear();
    month   = date.getMonth();
    day     = date.getDate();
    hours   = "0" + date.getHours();
    minutes = "0" + date.getMinutes();
    seconds = "0" + date.getSeconds();
    
    if(returnTime == undefined || returnTime == true) return day+' '+monthNames[month]+' '+year+'г.'+' в '+hours.substr(-2) + ':' + minutes.substr(-2); // + ':' + seconds.substr(-2);
    else if(! returnTime) return day+' '+monthNames[month]+' '+year+'г.'; // + ':' + seconds.substr(-2);
};
    
    



// возвращает дату в человекопонятном виде из строки, к примеру 2016-04-01
getDateFromString = function(dateString) {
    var monthNames = {1: 'января', 2: 'февраля', 3: 'марта', 4: 'апреля', 5: 'мая', 6: 'июня', 7: 'июля', 8: 'августа', 9: 'августа', 10: 'октября', 11: 'ноября', 12: 'декабря'};

    var year = month = day = hours = minutes = seconds = 0;
    
    var dateArr = dateString.split('-');
    
    year    = (1 * dateArr[0]);
    month   = (1 * dateArr[1]);
    day     = (1 * dateArr[2]);
    
    return day+' '+monthNames[month]+' '+year+'г';
};







// конвертирует маску времени в человекопонятный вид, к примеру m:3 - 3 месяца
encodeTimePoint = function(point) {
    var nnn = ['y', 'm', 'd', 'h', 'i', 's'];
    var decodeData = point.split(':');
    if(nnn.indexOf( decodeData[0]) == -1) {console.log('encodeTimePoint неверные данные'); return;}
    
    var poriodName = decodeData[0];
    var periodCount = decodeData[1];
    
    
    var yN = ['год', 'года', 'лет'];
    var mN = ['месяц', 'месяца', 'месяцев'];
    var dN = ['день', 'дня', 'дней'];
    var hN = ['час', 'часа', 'часов'];
    var iN = ['минута', 'минуты', 'минут'];
    var sN = ['секунда', 'секунды', 'секунд'];
    
    var perNames = {
        'y': {0: yN[2], 1: yN[0], 2: yN[1], 3: yN[1], 4: yN[1], 5: yN[2], 6: yN[2], 7: yN[2], 8: yN[2], 9: yN[2], 11: yN[2], 12: yN[2], 13: yN[2],14: yN[2]},
        'm': {0: mN[2], 1: mN[0], 2: mN[1], 3: mN[1], 4: mN[1], 5: mN[2], 6: mN[2], 7: mN[2], 8: mN[2], 9: mN[2], 11: mN[2], 12: mN[2], 13: mN[2],14: mN[2]},
        'd': {0: dN[2], 1: dN[0], 2: dN[1], 3: dN[1], 4: dN[1], 5: dN[2], 6: dN[2], 7: dN[2], 8: dN[2], 9: dN[2], 11: dN[2], 12: dN[2], 13: dN[2],14: dN[2]},
        'h': {0: hN[2], 1: hN[0], 2: hN[1], 3: hN[1], 4: hN[1], 5: hN[2], 6: hN[2], 7: hN[2], 8: hN[2], 9: hN[2], 11: hN[2], 12: hN[2], 13: hN[2],14: hN[2]},
        'i': {0: iN[2], 1: iN[0], 2: iN[1], 3: iN[1], 4: iN[1], 5: iN[2], 6: iN[2], 7: iN[2], 8: iN[2], 9: iN[2], 11: iN[2], 12: iN[2], 13: iN[2],14: iN[2]},
        's': {0: sN[2], 1: sN[0], 2: sN[1], 3: sN[1], 4: sN[1], 5: sN[2], 6: sN[2], 7: sN[2], 8: sN[2], 9: sN[2], 11: sN[2], 12: sN[2], 13: sN[2],14: sN[2]},
    }
    
    var decodeData = point.split(':');
    var poriodName = decodeData[0];
    var periodCount = decodeData[1];
    
    var res;
    if(periodCount.length > 1) {
        if(perNames[poriodName][periodCount] != undefined) res = perNames[poriodName][periodCount]; 
        else {
            if(perNames[poriodName][periodCount.substr(-2)] != undefined) {
                res = perNames[poriodName][periodCount.substr(-2)];
            } else {
                res = perNames[poriodName][periodCount.substr(-1)];
            } 
        } 
    } else {
        res = perNames[poriodName][periodCount.substr(-1)];
    }
    
    return [periodCount, res];
}











// смещение временной зоны
// - вернуть в часах минутах или секундах (h m i)
getClientTimeZone = function(unitName) {
    var uName = unitName != undefined ? unitName : 'm';
    var time = new Date();
    var timeOffset = parseInt(time.getTimezoneOffset());
    
    if(uName == 'h') timeOffset = timeOffset / 60;
    else if(uName == 'i') timeOffset = timeOffset * 60;
    
    return timeOffset + 3; // +3 это поправка по МСК если поставить в настройках index.php date_default_timezone_set UTC - то поправка не нужна
}



