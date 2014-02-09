if ( ! function_exists( 'logd' ) ) {
  //log_messageのラッパー
  //log_messageが長い上に引数の順序が非常に気に入らないので
  //短縮形のラッパを作った（デフォルトログレベルはdebug）
  //ついでに引数に配列、オブジェクトを渡せるようにした。
  //ついでに呼出元ファイル名、行番号、メソッド名を追記を可能にした

  function logd($data , $add_str='', $level='debug' , $show_filename=true)
  {

    //配列、オブジェクトは自動展開する
    if(is_array($data) || is_object($data)){
      $space = "\n";
      $message = print_r($data,true) . $space . $add_str ;

    }else{
      $space = ' ';
      $message = $data . $space . $add_str ;
    }

    if($show_filename){
      $dbg = debug_backtrace();
      //呼出元ファイル名、行番号、メソッド名を追記
      $fname = ( isset($dbg[0]['file'] ) ) ? 'FILE:' . $dbg[0]['file'] : '';
      $line = ( isset($dbg[0]['line'] ) ) ? ' , LINE:' . $dbg[0]['line'] : '';
      $func = ( isset($dbg[1]['function'] ) ) ? ' , FUNCTION:' . $dbg[1]['function'] : '';
      $message = '[' . $fname . $line . $func . ']' . $space . $message ;
    }
    log_message($level , $message);
  }
}