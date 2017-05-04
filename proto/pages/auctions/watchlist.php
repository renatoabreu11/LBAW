<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/auctions.php');

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

$auctions = getWatchlistAuctionsOfUser($id);
/*
foreach ($auctions as &$auction) {
	echo $seller_id = $auction['user_id'] . "\n";
}*/

$notifications = getActiveNotifications($id);

$items = 4;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('auctions', $auctions);
$smarty->display('auctions/watchlist.tpl');