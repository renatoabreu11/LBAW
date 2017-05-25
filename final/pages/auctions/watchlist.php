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

// add 'active' and 'myAuction' attributes to each auction
foreach ($auctions as &$auction) {
	$seller_id = $auction['user_id'];
	$auction['winner'] = getWinningUser($auction['id']);
	if ($seller_id == $id)
		$auction['myAuction'] = 1;
	else
		$auction['myAuction'] = 0;

	if ($auction['state'] == 'Open' || $auction['state'] == 'Created')
		$auction['active'] = 1;
	else
		$auction['active'] = 0;

	if ($auction['image'] == null) 
		$auction['image'] = 'default.jpeg';
  $auction['end_date_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
  $auction['start_date_readable'] = date('d F Y, H:i:s', strtotime($auction['start_date']));
}

$notifications = getActiveNotifications($id);
foreach ($notifications as &$n){
  $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
}

$items = 4;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign("module", "Auctions");
$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('auctions', $auctions);
$smarty->display('auctions/watchlist.tpl');