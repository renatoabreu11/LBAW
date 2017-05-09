<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/auctions.php');
include_once ($BASE_DIR . 'database/users.php');
include_once ($BASE_DIR . 'database/admins.php');

$categories = getCategories();
$numActiveAuctions = getNumActiveAuctions();
$totalValOfActiveAuctions = getTotalValueOfActiveAuctions();
$topTenRankingUsers = getTopTenRankingUsers();
$mostPopularAuctions = getMostPopularAuctions();
$mostRecentAuction = getMostRecentAuction();
$mostRecentAuctionImage = getAuctionImage($mostRecentAuction['auction_id']);

if ($mostRecentAuction['image_filename'] == null)
	$mostRecentAuction['image_filename'] = 'default.jpeg';

foreach ($mostPopularAuctions as &$auction) {
	if ($auction['image'] == null) 
		$auction['image'] = 'default.jpeg';
}

if($totalValOfActiveAuctions == null){
  $totalValOfActiveAuctions = 0;
}

if($_SESSION['user_id']){
  $id = $_SESSION['user_id'];
  $notifications = getActiveNotifications($id);
  $smarty->assign('notifications', $notifications);
}

$smarty->assign('categories', $categories);
$smarty->assign('numActiveAuctions', $numActiveAuctions);
$smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
$smarty->assign('topTenRankingUsers', $topTenRankingUsers);
$smarty->assign('auctions', $mostPopularAuctions);
$smarty->assign('mostRecentAuction', $mostRecentAuction);
$smarty->assign('mostRecentAuctionImage', $mostRecentAuctionImage);
$smarty->display('auctions/list_best_auctions.tpl');