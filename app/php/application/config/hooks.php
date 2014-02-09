<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
| -------------------------------------------------------------------------
| Hooks
| -------------------------------------------------------------------------
| This file lets you define "hooks" to extend CI without hacking the core
| files.  Please see the user guide for info:
|
|	http://codeigniter.com/user_guide/general/hooks.html
|
*/

//開発時に自動的にプロファイラを有効にする
$hook['post_controller_constructor'][] = array(
'class' => 'MyClasses',
'function' => 'enable_profiler',
'filename' => 'MyClasses.php',
'filepath' => 'hooks'
);
//for my_classes


/* End of file hooks.php */
/* Location: ./application/config/hooks.php */
