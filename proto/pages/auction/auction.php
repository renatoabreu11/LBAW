<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/auction.php');
include_once ($BASE_DIR . 'database/auctions.php');
include_once ($BASE_DIR . 'database/users.php');

$auctionId = $_GET["id"];
$auction = getAuction($auctionId);

$auction['end_data_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
$product = getAuctionProduct($auctionId);
$productCategories = getProductCategories($product['id']);
$images = getProductImages($product['id']);

$seller = getUser($auction['user_id']);
$numReviews = count(getReviews($auction['user_id']));

$recentBidders = getRecentBidders($auctionId);
$numBids = getTotalNumBids($auctionId);
$numBidders = count(getBidders($auctionId));

$questions = getQuestionsAnswers($auctionId);
$similarAuctions = getSimilarAuctions($auctionId);

foreach ($similarAuctions as &$auctions) {
  if ($auctions['image'] == null)
    $auctions['image'] = 'default.jpeg';
}

if(date('Y-m-d H:i:s') > $auction['end_date']) {
  $winningUser = getWinningUser($auctionId);
  $smarty->assign("winningUser", $winningUser);
}

$canEdit = true;
if(strtotime($auction['start_date']) - strtotime(date('Y-m-d H:i:s')) < 0){
  $canEdit = false;
}

if($_SESSION['user_id']){
  $id = $_SESSION['user_id'];
  $username = $_SESSION['username'];
  $notifications = getActiveNotifications($id);
  $isOnWatchlist = isOnWatchlist($id, $auctionId);
  $smarty->assign('username', $username);
  $smarty->assign('notifications', $notifications);
  $smarty->assign('isOnWatchlist', $isOnWatchlist);
}

if(count($images) == 0){
  $images = array(['description' => 'Image not available', 'filename' => 'default.jpeg']);
}

$smarty->assign("canEdit", $canEdit);
$smarty->assign("images", $images);
$smarty->assign("product", $product);
$smarty->assign("productCategories", $productCategories);
$smarty->assign("auction", $auction);
$smarty->assign("seller", $seller);
$smarty->assign("numReviews", $numReviews);
$smarty->assign("recentBidders", $recentBidders);
$smarty->assign("numBids", $numBids);
$smarty->assign("numBidders", $numBidders);
$smarty->assign("questions", $questions);
$smarty->assign("similarAuctions", $similarAuctions);

$smarty->display('auction/auction.tpl');