<?php
/**
 * Arcadiaからページを取得し、データベースへ挿入するクラスです。
 * User: yuggr
 * Date: 12/10/15
 * Time: 20:11
 */
class Categories extends CI_Controller
{
  public function __construct()
  {
      parent::__construct();
      $this->load->model('categories_model');
  }

  public function index(){
    $data = $this->categories_model->find_all();
    $json =  json_encode($data);

    $this->output
        ->set_content_type('json')
        ->set_output($json);
  }
}