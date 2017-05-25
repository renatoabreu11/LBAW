<?php

include_once ('../../config/init.php');

$username = $_SESSION['username'];
$userId = $_SESSION['user_id'];
$token = $_SESSION['token'];

if($username && $userId && $token){
  header("Location: $BASE_URL");
  exit;
}

$smarty->assign("module", "Auth");
$smarty->display('authentication/recovery.tpl');