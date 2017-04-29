<?php

function clean($string) {
  return preg_replace('/[^A-Za-z0-9\,\s]/', '', $string); // Removes special chars.
}

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auction.php');
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

$auctionId = $_GET['id'];

if(!isOwner($id, $auctionId)){
  header("Location: $BASE_URL");
  return;
}

$categories = getCategories();
$product = getAuctionProduct($auctionId);
$auction = getAuction($auctionId);
$notifications = getActiveNotifications($id);
$auctionTypes = getAuctionTypes();
$watchlist = getWatchlistInfo($id, $auctionId);

$types = $product['type'];
$cleanTypes = clean($types);
$productType = explode(',', $cleanTypes);

$smarty->assign('productType', $productType);
$smarty->assign('watchlist', $watchlist);
$smarty->assign('categories', $categories);
$smarty->assign('auctionTypes', $auctionTypes);
$smarty->assign('notifications', $notifications);
$smarty->assign("auction", $auction);
$smarty->assign("product", $product);
$smarty->display('auction/auction_edit.tpl');