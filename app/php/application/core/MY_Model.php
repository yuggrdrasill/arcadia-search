<?php
/**
 * Created by JetBrains PhpStorm.
 * User:
 * Date: 12/09/16
 * Time: 19:56
 * To change this template use File | Settings | File Templates.
 */
class MY_Model extends CI_Model
{

    /**
     * table name
     *
     * @var string
     */
    protected $_table;

    /**
     * constructor
     */
    public function __construct() {
        parent::__construct();
        $this->load->database();
        $clazz = get_class($this);
        $this->_table = strtolower(substr($clazz, 0, strpos($clazz, '_')));
    }

    /**
     * insert
     *
     * @return integer
     */
    public function add($value = null) {
        if($value == null)
            $value = $this;
        $now = $this->now();
        $this->db->set(array('created_at' => $now, 'updated_at' => $now));
        $ret = $this->db->insert($this->_table, $value);
        if ($ret === FALSE) {
            return FALSE;
        }
        return $this->db->insert_id();
    }

    /**
     * update
     *
     * @param integer|string $id
     */
    public function update($id, $data = null) {
        if ($data === null) {
            $data = $this;
        }
        $now = $this->now();
        $this->db->set(array('updated_at' => $now));
        $ret = $this->db->update($this->_table, $data, array('id' => $id));
        if ($ret === FALSE) {
            return FALSE;
        }
    }

    /**
     * update
     * @param array|$data
     * @param string|$where
     */
    public function update_alt($data,$where){
        $now = $this->now();
        $this->db->set(array('updated_at' => $now));
        $ret = $this->db->update($this->_table, $data, $where);
        if ($ret === FALSE) {
            return FALSE;
        }
    }


    /**
     * delete
     *
     * @param integer|strng $id
     */
    public function delete($id) {
        $this->db->delete($this->_table, array('id' => $id));
    }

    /**
     * find_all
     *
     * @return array
     */
    public function find_all() {
        return $this->db->get($this->_table)->result();
    }

    /**
     * find_list
     *
     * @param  integer|string $limit
     * @return array
     */
    public function find_list($limit = 10) {
        return $this->db->limit($limit)->order_by('id')->get($this->_table)->result();
    }

    /**
     * find
     *
     * @param  integer|string $id
     * @return stdClass
     */
    public function find($id) {
        $ret = $this->db->where(array('id' => $id))->get($this->_table)->row();
        return $ret;
    }

    /**
     * now
     *
     * @return string
     */
    public function now() {
        date_default_timezone_set('Asia/Tokyo');
        return date('Y-m-d H:i:s');
    }

    public function cache_delete_all(){
        $this->db->cache_delete_all();
    }

    public function cache_delete($page_name , $method_name){
        $this->db->cache_delete($page_name,$method_name);
    }
}
