if ( ! function_exists( 'logd' ) ) {
  //log_message�̃��b�p�[
  //log_message��������Ɉ����̏��������ɋC�ɓ���Ȃ��̂�
  //�Z�k�`�̃��b�p��������i�f�t�H���g���O���x����debug�j
  //���łɈ����ɔz��A�I�u�W�F�N�g��n����悤�ɂ����B
  //���łɌďo���t�@�C�����A�s�ԍ��A���\�b�h����ǋL���\�ɂ���

  function logd($data , $add_str='', $level='debug' , $show_filename=true)
  {

    //�z��A�I�u�W�F�N�g�͎����W�J����
    if(is_array($data) || is_object($data)){
      $space = "\n";
      $message = print_r($data,true) . $space . $add_str ;

    }else{
      $space = ' ';
      $message = $data . $space . $add_str ;
    }

    if($show_filename){
      $dbg = debug_backtrace();
      //�ďo���t�@�C�����A�s�ԍ��A���\�b�h����ǋL
      $fname = ( isset($dbg[0]['file'] ) ) ? 'FILE:' . $dbg[0]['file'] : '';
      $line = ( isset($dbg[0]['line'] ) ) ? ' , LINE:' . $dbg[0]['line'] : '';
      $func = ( isset($dbg[1]['function'] ) ) ? ' , FUNCTION:' . $dbg[1]['function'] : '';
      $message = '[' . $fname . $line . $func . ']' . $space . $message ;
    }
    log_message($level , $message);
  }
}