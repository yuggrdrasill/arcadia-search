<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <title>Batch WEB interface</title>
  <link rel="stylesheet" href="/css/app.css">
  <script type="text/javascript" src="/partials/sha512.js"></script>
</head>
<body>

<div id="container">
  <h1>Batchを実行するためにはパスワードを入力してください</h1>
  <div id="contents">
      <?php
        $attributes = array('id' => 'form-main' ,'name' => 'batch');
        echo form_open('batch/index',$attributes)
      ?>
        <label for="password">パスワード</label>
      <?php
        $attributes = array(
            'name' => 'password',
            'type' =>'password',
            'class' => 'password',
            'id' => 'password',
            'required' => 'required'
        );
        echo form_input($attributes);
      ?>
      <?php
        $attributes = array(
            'name' => 'post',
            'type' => 'submit',
            'class' => 'post',
            'id' => 'post',
            'value' => '送信'
        );
        echo form_submit('post', '送信');
      ?>
    </form>
  </div>

</div>

<script type="text/javascript">
  var mainForm = document.getElementById("form-main");
  mainForm.addEventListener('submit', function(){
    var password = document.getElementById('password');
    var cryptPassword = SHA512(password.value);
    password.value = cryptPassword;
    document.forms["batch"].submit();
  }, true);
</script>

</body>
</html>