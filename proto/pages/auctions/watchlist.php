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
$now = strtotime(date('Y/m/d h:i:s a', time()));

// add 'active' and 'myAuction' attributes to each auction
foreach ($auctions as &$auction) {
	$seller_id = $auction['user_id'];
	$end_date = strtotime($auction['end_date']);

	if ($seller_id == $id)
		$auction['myAuction'] = 1;
	else
		$auction['myAuction'] = 0;

	if ($end_date > $now)
		$auction['active'] = 1;
	else
		$auction['active'] = 0;
}

$notifications = getActiveNotifications($id);

$items = 4;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('auctions', $auctions);
$smarty->display('auctions/watchlist.tpl');