<?php
/**
 * User: yuggr
 * Date: 12/09/16
 * Time: 20:03
 */
/** @noinspection PhpUndefinedClassInspection */
class Categories_model extends MY_Model
{
    public $id;
    public $name;
    public $key_name;
    public $updated_at;
    public $created_at;

    private $table_cache;

    /**
     * constructor
     */
    public function __construct() {
        parent::__construct();
        $this->table_cache = $this->find_all();
    }

    public function get_cache(){
      return $this->table_cache;
    }
}
