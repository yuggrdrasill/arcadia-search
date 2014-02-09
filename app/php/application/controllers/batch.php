<?php
/**
 * Arcadiaからページを取得し、データベースへ挿入するクラスです。
 * User: yuggr
 * Date: 12/10/15
 * Time: 20:11
 */
class Batch extends CI_Controller
{
    private $password;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('novels_model');
        $this->load->library('html_dom');
        $this->load->model('pageviews_model');

        $this->load->helper('form');
    }

    /**
     *
     */
    public function index()
    {
        $this->db->cache_delete_all();
        $this->arcadia();
    }

    /**
     * Arcadiaからデータを取得し、DBへ登録します。
     */
    public function arcadia()
    {
        if($this->input->is_cli_request()){
            $url = "http://search-arcadia.jp:9999/db/sst.html";
            $url = "http://www.mai-net.net/bbs/sst/sst.php?act=list&page=1&cate=";

            $novels = $this->parse_html($url . 'all');
            $this->update_novels($novels);

            sleep(3);

            $tiraura = true;
            $novels = $this->parse_html($url . 'tiraura',$tiraura);
            $this->update_novels($novels);
        } else {
            $this->load->view('batch');
        }
    }

    /**
     * 渡されたパスワードとapplicationに設定されているパスワードを比較し、
     * 合っているかどうか調べます。
     * @param String $input_password 入力パスワード
     */
    private function check_password($input_password){
        $this->password = hash('sha512', "V91thkSE");
        $sha512 = hash('sha512', $input_password);
        if($this->password == $sha512){
            return true;
        }
        return false;
    }

    public function from_file($category = "" ,$number = ""){
        if($this->input->is_cli_request()){
            $this->output->enable_profiler(TRUE);
            $novels = array();
            $message = "from local file $category<br>\n";
            log_message("debug",$message);
            $this->output->append_output($message);

            $category == "tiraura" ? $tiraura = true : $tiraura = false;

            if($number){
                $novels =
                    $this->parse_html(
                        "http://search-arcadia.jp:9999/sst$number.htm"
                        ,$tiraura
                    );
            } else {
                $novels =
                    $this->parse_html(
                        "http://search-arcadia.jp:9999/sst.htm"
                        ,$tiraura
                    );
            }
            $this->update_novels($novels);
        }
    }

    /**
     * simple_domエレメントブロックから小説データを生成します。
     * @param $elem simple_domエレメントブロック
     * @param bool $first_row 最初の行ならばTRUEを指定する
     * @return array
     */
    private function build_novel_data($elem, $first_row = false ,$tiraura = false)
    {
        $i = 0;
        if ($first_row)
            // 最初の行のChildren(0)にはカテゴリが入っているため飛ばしてから開始
            $i = 1;
        preg_match('/\d+/', $elem->children($i + 1)->innertext, $id);

        $year = date("Y");
        $month = date("M");
        // 一ページ内で一二月と一月がまたがっている場合、振り分ける
        if ($month == 1 && preg_match('/12\//', $elem->children($i + 7)->plaintext))
            $year--;

        // チラ裏はフィールドが少ないため振り分ける
        if($tiraura){
            $title = $elem->children($i + 1)->plaintext;
            $novelist = $elem->children($i + 2)->plaintext;
            $novel_count = $elem->children($i + 3)->plaintext;
            $novel_updated_at = $year . '/' . $elem->children($i + 4)->plaintext;

            log_message(
                'debug'
                ,": チラシの裏 :
                  : id: $id[0]
                  : title : $title
                  : novelist : $novelist
                  : novel_count : $novel_count
                  : novel_updated_at :$novel_updated_at");

            return $novels = array(
                'id' => $id[0],
                'category' => 'チラシの裏',
                'title' => $title,
                'novelist' => $novelist,
                'novel_count' => $novel_count,
                'novel_updated_at' => $novel_updated_at
            );
        }
        return $novels = array(
            'id' => $id[0],
            'category' => $elem->children($i)->plaintext,
            'title' => $elem->children($i + 2)->plaintext,
            'novelist' => $elem->children($i + 3)->plaintext,
            'novel_count' => $elem->children($i + 4)->plaintext,
            'review_count' => $elem->children($i + 5)->plaintext,
            'pv' => $elem->children($i + 6)->plaintext,
            'novel_updated_at' => $year . '/' . $elem->children($i + 7)->plaintext,
        );
    }

    /**
     * 小説リストを受け取り、そのデータを使用してデータベースを更新します。
     * @param array $novels 小説リスト
     */
    private function update_novels($novels)
    {
        $this->db->trans_start();

        foreach ($novels as $novel) {
            $message_color = "red";
            $message_method = 'update';
            if ($this->novels_model->find($novel['id'])) {
                $this->novels_model->update($novel['id'], $novel);
            } else {
                $this->novels_model->add($novel);
                $message_color = "blue";
                $message_method = 'update';
            }
            $message = "<span style='color:$message_color'>$message_method: </span>";

            $message .= $novel['id']  . ' : '
                . $novel['category'] . ' : '
                . $novel['title'] . "<br>\n";
            $this->output->append_output($message);
            log_message('debug',$message);
        }
//        $this->db->trans_rollback();
//        $this->db->trans_commit();
        $this->db->trans_complete();
    }

    /**
     * 指定されたURLからファイルを取得し、小説リストに整形して返します。
     * @param $url String 取得URL またはファイル名
     * @param $tiraura boolean チラシの裏カテゴリかどうか
     * @return array
     */
    private function parse_html($url,$tiraura = false)
    {
        // Create DOM from URL or file
        $html = $this->html_dom->file_get_html($url);
        // 一番目にはカテゴリや広告が含まれるため別処理
        $elem = $html->find('#table tr.bgc');
        $novel = $this->build_novel_data($elem[0], true,$tiraura);
        $novels[] = $novel;


        unset($elem[0]);
        // Find all images
        foreach ($elem as $element)
            $novels[] = $this->build_novel_data($element,false,$tiraura);
        return $novels;
    }

}
