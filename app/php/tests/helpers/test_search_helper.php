<?php
class test_search_helper extends CodeIgniterUnitTestCase
{
    public function __construct()
    {
        parent::__construct();
        $this->load->helper('search');
    }

    public function setUp()
    {
    }

    public function tearDown()
    {
    }

    public function test_included()
    {
    }

    /**
     * privateメソッドを実行します。
     * @param $class 実行するインスタンスクラス
     * @param $class_name クラス名
     * @param $method_name 実行メソッド名
     * @param $value メソッド実行引数
     * 
     * @return 実行結果
     */
    protected function execute_private_method($class_name, $class, $method_name, $value)
    {
        $private_method = new ReflectionMethod($class_name, $method_name);
        $private_method->setAccessible(true);
        return $private_method->invoke($class,$value);
    }

    /*
     * 半角空白をパーステスト
     */
    public  function test_parse_by_halfwidth()
    {
        $result = parse_text("完結 ドラゴン");
        $this->assertEqual($result['include'] ,array("完結","ドラゴン"),"AND検索文字列が存在すること");
        $this->assertEqual(count($result['exclude']),0,"NOT検索文字列が存在しないこと");
    }

    /*
     * 全角空白をパーステスト
     */
    public function test_parse_by_fullwidth()
    {
        $result = parse_text("なのは　転生");
        $this->assertEqual($result['include'] ,array("なのは","転生"),"AND検索文字列が存在すること");
        $this->assertEqual(count($result['exclude']),0,"NOT検索文字列が存在しないこと");
    }

    /*
     * 半角空白・全角空白混合をパーステスト
     */
    public function test_parse_by_halfwidth_and_fullwidth()
    {
        $result = parse_text("なのは　転生 ini");
        $this->assertEqual($result['include'] ,array("なのは","転生","ini"),"AND検索文字列が存在すること");
        $this->assertEqual(count($result['exclude']),0,"NOT検索文字列が存在しないこと");
    }

    /*
     * AND検索・NOT検索混合テキストをパーステスト
     */
    public function test_parse_text_by_minus()
    {
        $result = parse_text("なのは　-転生 ini -vivid");
        $this->assertEqual($result['include'] ,array("なのは","ini"),"AND検索文字列が存在すること");
        $this->assertEqual($result['exclude'] ,array("転生","vivid"),"NOT検索文字列が存在すること");
    }

    /*
     * 否定検索テキストをパーステスト
     */
    public function test_parse_text_by_minus_only()
    {
        $result = parse_text("-ドラゴン -オリ主");
        $this->assertEqual(count($result['include']) ,0,"AND検索文字列が存在しないこと");
        $this->assertEqual($result['exclude'] ,array("ドラゴン","オリ主"),"AND検索文字列が存在すること");
    }

    /*
     * 中間にマイナスが入っている語句をテスト
     */
    public function test_parse_text_by_middle_minus()
    {
        $result = parse_text('muv-luv チート　愛');
        $this->assertEqual($result['include']
            ,array('muv-luv','チート','愛'),"AND検索文字列が存在すること");
        $this->assertEqual($result['exclude'] ,array(),"NOT検索文字列が存在しないこと");


    }
}

/* End of file test_vmodel_model.php */
/* Location: ./tests/models/test_vmodel_model.php */
