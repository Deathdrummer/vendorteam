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
        return base64_encode($str.'346045267804235468667352353ddr');
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
        $str =  str_replace('346045267804235468667352353ddr', '', $decrypt);
        if (is_numeric($str)) $str = $str / 567;
        return $str;
    }
}