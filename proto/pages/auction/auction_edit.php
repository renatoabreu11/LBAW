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
  header("Location: $BASE_URL");
  return;
}

$auctionId = $_GET['id'];

if(!isOwner($id, $auctionId)){
  header("Location: $BASE_URL");
  return;
}

$auction = getAuction($auctionId);

if(strtotime($auction['start_date']) - strtotime(date('Y-m-d H:i:s')) < 0){
  header("Location:"  . $BASE_URL . 'pages/auction/auction.php?id=' . $auctionId);
  return;
}

$categories = getCategories();
$product = getAuctionProduct($auctionId);
$notifications = getActiveNotifications($id);
$auctionTypes = getAuctionTypes();
$watchlist = getWatchlistInfo($id, $auctionId);
$productTypes = getProductCategories($product['id']);
$characteristics = getProductCharacteristics($product['id']);

$auction['start_date'] = date('d/m/y h:m', strtotime($auction['start_date']));
$auction['end_date'] = date('d/m/y h:m', strtotime($auction['end_date']));

$smarty->assign('productTypes', $productTypes);
$smarty->assign('watchlist', $watchlist);
$smarty->assign('categories', $categories);
$smarty->assign('auctionTypes', $auctionTypes);
$smarty->assign('notifications', $notifications);
$smarty->assign('characteristics', $characteristics);
$smarty->assign("auction", $auction);
$smarty->assign("product", $product);
$smarty->display('auction/auction_edit.tpl');