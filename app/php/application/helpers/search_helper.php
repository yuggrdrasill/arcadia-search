<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * User: yuggr
 * date: 12/11/06
 * @category	Helpers
 */
/** @noinspaction PhpUndefinedClassInspection */

if (! function_exists('parse_text')) {
    
    /*
     * 渡された引数をスペースとマイナス(-)で分解し配列へ格納します。
     */
    function parse_text($text)
    {
        $result = array("include" => array(),"exclude" => array());
        $split = preg_split('/[ 　]/u', $text);

        foreach ($split as $value) {
            $result = _build_search_array($value, $result);
        }

        return $result;
    }

    /**
     * 検索用文字列の配列を生成します。
     * @param $value 文字列
     * @param array $result
     * @return mixed
     */
    function _build_search_array($value,$result)
    {
        if ($value) {
            $result = _get_search_text($value, $result);
            return $result;
        }
        return $result;
    }

    /**
     * AND検索かNOT検索かチェックを行い、検索用文字列の配列に追加します。
     * @param $value    検索文字列
     * @param array $result   検索文字列配列
     * @return mixed
     *      'include' => AND検索用文字列,
     *      'exclude' => NOT検索用文字列
     */
    function _get_search_text($value,array $result)
    {
        if (_is_not_search_word($value)) {
            $result['exclude'][] = substr($value, 1, strlen($value));
        } else {
            $result['include'][] = $value;
        }
        return $result;
    }

    /**
     * 渡されたTEXT内にNOT検索が含まれるかチェックします。
     * @param $text
     * @return bool
     */
    function _is_not_search_word($text)
    {
        return preg_match('/^-/',$text) ? true : false;
    }
}
