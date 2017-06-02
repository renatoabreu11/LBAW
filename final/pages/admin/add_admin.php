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

$smarty->assign("module", "Admin");
$smarty->assign("adminSection", "addAdmin");
$smarty->assign("title", "SeekBid - Administration");
$smarty->display('admin/admin_page.tpl');