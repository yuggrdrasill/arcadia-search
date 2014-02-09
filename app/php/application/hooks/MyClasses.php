<?php  if ( ! defined( 'BASEPATH' ) ) exit( 'No direct script access allowed' );

class MyClasses {
    /**
     * includes the directory application\my_classes\ in your includes directory
     */
    function index()
    {
        // includes the directory application\my_classes\
        // for windows tests change the ':' before APPPATH to ';'
        // Zend Framework、その他独自移植ライブラリ用のパスの読み込み
        ini_set( 'include_path', ini_get( 'include_path' ) . ':' . APPPATH . 'my_classes/' );
    }
    function enable_profiler()
    {
        //開発時に自動的にプロファイラを有効にする
        if ( config_item( 'my_debugger' ) ) {
            $CI = &get_instance();
            $CI -> output -> enable_profiler( true );
        }
    }
}

/* End of file MyClasses.php */
/* Location: ./application/hooks/MyClasses.php */
