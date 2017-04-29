<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];
$token = $_SESSION['token'];

if(!$username || !$id || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!validUser($username, $id)){
  header("Location: $BASE_URL");
  return;
}

if(!isset($_GET['id'])){
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  return;
}

$notifications = getActiveNotifications($_SESSION['user_id']);
$categories = getCategories();

$smarty->assign('notifications', $notifications);
$smarty->assign("categories", $categories);
$smarty->display('auction/create_auction.tpl');