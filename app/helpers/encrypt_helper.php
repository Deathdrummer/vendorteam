<?

if (!function_exists('encrypt')) {
    /**
     * 
     * @param 
     * @return
    */
    function encrypt($str = false) {
        if (!$str) return false;
        if (is_numeric($str)) $str = $str * 567;
        return base64_encode(($str.'346045267804235468667352353ddr'));
    }
}


if (!function_exists('decrypt')) {
    /**
     * 
     * @param 
     * @return
    */
    function decrypt($str = false) {
        if (!$str) return false;
        $decrypt = base64_decode($str);
        $str = str_replace('346045267804235468667352353ddr', '', $decrypt);
        if (is_numeric($str)) $str = $str / 567;
        return $str;
    }
}





if (!function_exists('cyrillicEncode')) {
    /**
     * Закодировать имена директорий и файлов
     * @param строка
     * @return закодированная строка
    */
    function cyrillicEncode($str = false) {
        if (!$str) return false;   
        $map = config_item('map');
        $search = array_keys($map);
        $replace = array_values($map);
        return str_replace($search, $replace, (trim($str)));
    }
}



if (!function_exists('cyrillicDecode')) {
    /**
     * Раскодировать имена директорий и файлов
     * @param строка
     * @return раскодированная строка
    */
    function cyrillicDecode($str = false) {
        if (!$str) return false;   
        $map = config_item('map');
        $search = array_values($map);
        $replace = array_keys($map);
        return str_replace($search, $replace, $str);
    }
}