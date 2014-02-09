<?php
/**
 * User: yuggr
 * Date: 12/09/16
 * Time: 20:03
 */
/** @noinspection PhpUndefinedClassInspection */
class Novels_model extends MY_Model
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

    public function set_field($novel)
    {
        $this->id = $novel['id'];
        $this->category = $novel['category'];
        $this->title = $novel['title'];
        $this->novelist = $novel['novelist'];
        $this->novel_count = $novel['novel_count'];
        $this->review_count = isset($novel['review_count']) ? $novel['review_count'] : null;
        $this->pv = isset($novel['pv']) ? $novel['pv'] : null;
        $this->novel_updated_at = $novel['novel_updated_at'];

        return $this;
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
    public function find_novels($text = "", $limit = 50
        , $offset = 0, $order_by = "novel_updated_at", $asc = false)
    {
        $this->_add_like($text);
        $assoc = $asc ? "ASC" : " DESC";

        $this->db->order_by($order_by, $assoc);
        $this->db->order_by('id', $assoc);
        $this->db->limit($limit, $offset);

        return $this->db->get($this->_table)->result();
//        return $this->db->query($sql)->result();
    }

    private function _add_like($search_text)
    {
        $result = parse_text($text);

        foreach ($result['include'] as $value) {
            $this->db->like("title", $value);
        }
        foreach ($result['exclude'] as $value) {
            $this->db->not_like("title", $value);
        }

        $first = true;
        foreach ($result['include'] as $value) {
            if ($first) {
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

    private function _build_field_like_statement($field_name, $search_text)
    {
        $text_count = count($search_text['include']);
        $like = "";
        $count = 1;
        foreach ($search_text['include'] as $value) {
            $like = $like . $field_name . " LIKE \"%" . $this->db->escape_like_str($value) . "%\" ";

            if ($count < $text_count) {
                // 最後以外は追加する
                $like = $like . " AND ";
            }

            $count++;
        }
        return $like;
    }

    /*
     * 渡された引数をスペースとマイナス(-)で分解し配列へ格納します。
     */
    private function _parse_text($text)
    {
        return parse_text($text);
    }
}
