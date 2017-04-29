<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/auction.php');
include_once ($BASE_DIR . 'database/users.php');

$auction_id = $_GET["id"];
$auction = getAuction($auction_id);
$auction['end_data_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
$product = getAuctionProduct($auction_id);

$seller = getUser($auction['user_id']);
$numReviews = count(getReviews($auction['user_id']));

$recentBidders = getRecentBidders($auction_id);
$numBids = getTotalNumBids($auction_id);
$numBidders = count(getBidders($auction_id));

$questions = getQuestionsAnswers($auction_id);
$similarAuctions = getSimilarAuctions($auction_id);

if(date('Y-m-d H:i:s') > $auction['end_date']) {
  $winningUser = getWinningUser($auction_id);
  $smarty->assign("winningUser", $winningUser);
}

if(!$_SESSION['user_id']){
  $id = $_SESSION['user_id'];
  $token = $_SESSION['token'];
  $smarty->assign("userId", $id);
  $smarty->assign("token", $token);
}else if(!$_SESSION['admin_id']){
  $id = $_SESSION['admin_id'];
  $token = $_SESSION['token'];
  $smarty->assign("adminId", $id);
  $smarty->assign("token", $token);
}

$smarty->assign("product", $product);
$smarty->assign("auction", $auction);
$smarty->assign("seller", $seller);
$smarty->assign("numReviews", $numReviews);
$smarty->assign("recentBidders", $recentBidders);
$smarty->assign("numBids", $numBids);
$smarty->assign("numBidders", $numBidders);
$smarty->assign("questions", $questions);
$smarty->assign("similarAuctions", $similarAuctions);

$smarty->display('auction/auction.tpl');