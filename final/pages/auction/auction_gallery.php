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
  header("Location: $BASE_URL");
  return;
}

$auctionId = $_GET['id'];

if(!isOwner($id, $auctionId)){
  header("Location: $BASE_URL");
  return;
}

$auction = getAuction($auctionId);

if($auction['state'] != 'Created'){
  header("Location:"  . $BASE_URL . 'pages/auction/auction.php?id=' . $auctionId);
  return;
}

$product = getAuctionProduct($auctionId);
$notifications = getActiveNotifications($id);
foreach ($notifications as &$n){
  $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
}

$smarty->assign("module", "Auction");
$smarty->assign('notifications', $notifications);
$smarty->assign("product", $product);
$smarty->assign("auction", $auction);
$smarty->display('auction/auction_gallery.tpl');