<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auction.php');

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

$auction_id = $_GET['id'];

if(!isOwner($id, $auction_id)){
  header("Location: $BASE_URL");
  return;
}

$product = getAuctionProduct($auction_id);
$notifications = getActiveNotifications($id);

$smarty->assign('notifications', $notifications);
$smarty->assign("userId", $id);
$smarty->assign("token", $token);
$smarty->assign("product", $product);
$smarty->display('auction/auction_gallery.tpl');