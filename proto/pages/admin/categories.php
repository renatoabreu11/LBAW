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

$categories = getCategories();

$smarty->assign("adminId", $id);
$smarty->assign("token", $token);
$smarty->assign("categories", $categories);
$smarty->assign("adminSection", "categories");
$smarty->display('admin/admin_page.tpl');