<?php
/**
 * User: yuggr
 * Date: 12/09/16
 * Time: 20:03
 */
/** @noinspection PhpUndefinedClassInspection */
class VNovels_model extends MY_Model
{
    public $id;
    public $category;
    public $title;
    public $novelist;
  	public $novel_count;
  	public $review_count;
  	public $pv;
  	public $novel_updated_at;
  	public $updated_at;
  	public $created_at;

    public function __construct()
    {
        parent::__construct();
        $this->load->helper('search');
    }


    public function count($text = "")
    {
        $this->_add_like($text);

        return
            $this->db
                ->from($this->_table)
                ->count_all_results();
    }

    /*
     * @param string $text
     * @param int $limit
     */
    public function find_novels($text= "",$limit = 50
            ,$offset = 0,$order_by = "novel_updated_at_ori",$asc = false
            ,$past = false)
    {
//        $sql = $this->_build_sql($text,$limit,$offset,$order_by,$asc);
        $this->db->select("id
                          , category
                          , title
                          , novelist
                          , novel_count
                          , review_count
                          , pv
                          , novel_updated_at as novel_updated_at_ori
                          , DATE_FORMAT(`novel_updated_at`,'%Y/%m/%d %k:%i') as novel_updated_at
                          , updated_at
                          , created_at
                          , category_key", FALSE );
        $this->_add_like($text);
        $assoc = $asc ? "ASC":" DESC";

        $this->db->order_by($order_by,$assoc);
        $this->db->order_by('id',$assoc);
        if(!$past){
          $this->db->limit($limit,$offset);
        }

        $this->_set_past_search($past);

        return $this->db->get($this->_table)->result();
    }

    /**
    * 指定した数値の過去範囲に絞り込みます
    *
    * @param int $past_day 何日前か
    * @example
    *    _set_past_search(7) //7日前まで検索
    *    _set_past_search(14) //14日前まで検索
    */
    private function _set_past_search($past){
        if($past){
          $this->db->where(
            'novel_updated_at >='
            , date('Y-m-d', strtotime('-'.$past.' day'))
            );
        }
    }

    /**
      * 渡された文字列をlike文として追加します
      * @param String $search_text 検索ワード
    **/
    private function _add_like($search_text)
    {
        $result = $this->_parse_text($search_text);

        foreach ($result['include'] as $value) {
            $this->db->like("title", $value);
            $this->db->or_like("category", $value);
        }
        foreach ($result['exclude'] as $value) {
            $this->db->not_like("title", $value);
        }

        $first = true;
        foreach ($result['include'] as $value) {
            if($first){
                $this->db->or_like("novelist", $value);
                $first = false;
            } else {
                $this->db->like("novelist", $value);
            }
        }

        foreach ($result['exclude'] as $value) {
            $this->db->not_like("novelist", $value);
        }
    }

    /*
     * 渡された引数をスペースとマイナス(-)で分解し配列へ格納します。
     */
    private function _parse_text($text)
    {
        return parse_text($text);

        $result = array("include" => array(),"exclude" => array());
        $split = preg_split('/[ 　]/u', $text);

        foreach ($split as $value) {
            $result = $this->_build_search_array($value, $result);
        }

        return $result;
    }

    /**
     * 検索用文字列の配列を生成します。
     * @param $value 文字列
     * @param array $result
     * @return mixed
     */
    private function _build_search_array($value,$result)
    {
        if ($value) {
            $result = $this->_get_search_text($value, $result);
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
    private function _get_search_tgext($value,array $result)
    {
        if ($this->is_not_search_word($value)) {
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
    private function is_not_search_word($text)
    {
        return preg_match('/^-/',$text) ? true : false;
    }
}
