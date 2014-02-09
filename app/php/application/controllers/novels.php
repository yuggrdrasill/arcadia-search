<?php
/**
 * User: yuggr
 * Date: 12/09/16
 * Time: 21:40
 */
class Novels extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('vnovels_model');

    }

    public  function index($page = "1")
    {
        return $this->search();
    }

    /**
     * 受け取ったURLを元に小説を検索します。
     * category
     * startdate
     * enddate
     * sorttarget
     * reviewcountstart
     * reviewcountend
     * novelcount
     * pvstart
     * pvend
     * past
     * @param  string $text    検索フレーズ
     * @param  string $command ページコマンド名
     * @param  string $page    ページ番号
     * @return [String]          出力
     */
    public function search()
    {
        // $this->output->enable_profiler();
        $urlParam = $this->uri->uri_to_assoc(3);
        $page = isset($urlParam['page']) ? $urlParam['page'] : 1;
        $text = isset($urlParam['q']) ? $urlParam['q'] : "";
        // $urlParam['category'];
        // $urlParam['startdate'];
        // $urlParam['enddate'];
        // $urlParam['sorttarget'];
        // $urlParam['reviewcountstart'];
        // $urlParam['reviewcountend'];
        // $urlParam['novelcount'];
        // $urlParam['pvstart'];
        // $urlParam['pvend'];
        $past = isset($urlParam['past']) ? $urlParam['past'] : false;

        $limit = 50;

        $search_word = urldecode($text);
        $offset = 50 * ($page-1);
        $order_by = "novel_updated_at_ori";
        $asc = false;

        $data['count'] = $this->vnovels_model->count($search_word);
        $data['data'] =
            $this->vnovels_model
                    ->find_novels(
                        $search_word
                        ,$limit
                        ,$offset
                        ,$order_by
                        ,$asc
                        ,$past
                    );

        $json =  json_encode($data);

        $this->output
            ->set_content_type('json')
            ->set_output($json);
    }

    public function search_profile($text = "")
    {
        $this->output->enable_profiler(TRUE);
        $this->search($text);
        $this->output->set_content_type('html');
    }
}
