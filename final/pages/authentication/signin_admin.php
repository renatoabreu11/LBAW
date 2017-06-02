<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['username'];
$userId = $_SESSION['user_id'];
$token = $_SESSION['token'];

if($username && $userId && $token){
  header("Location: $BASE_URL");
  exit;
}

$smarty->assign("module", "Auth");
$smarty->assign("title", "Seek Bid - Admin sign in");
$smarty->display('authentication/signin_admin.tpl');