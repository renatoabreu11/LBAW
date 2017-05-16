<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['admin_username'];
$id = $_SESSION['admin_id'];
$token = $_SESSION['token'];

if(!$username || !$id || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!validAdmin($username, $id)){
  $smarty->display('common/404.tpl');
  return;
}

$feedback = getFeedback();

$smarty->assign("module", "Admin");
$smarty->assign("feedback", $feedback);
$smarty->assign("adminSection", "feedback");
$smarty->display('admin/admin_page.tpl');