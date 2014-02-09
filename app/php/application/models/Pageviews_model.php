<?php
/**
 * User: yuggr
 * Date: 12/09/16
 * Time: 20:03
 */
/** @noinspection PhpUndefinedClassInspection */
class Pageviews_model extends MY_Model
{
    public $id;
    public $novel_id;
    public $review_count;
    public $pv;
    public $created_at;

    /**
     * find_novel_id
     *
     * @param  integer|string id
     * @return array
     */
    public function find_novel_id($id) {
        return $this->db->where(array('novel_id' => $id))->get($this->_table)->result();
    }
}
