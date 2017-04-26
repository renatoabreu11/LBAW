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

    if($_SESSION['username'] && $_SESSION['user_id']){
        $notifications = getActiveNotifications($_SESSION['user_id']);
        $smarty->assign('notifications', $notifications);
    }

	$smarty->assign('categories', $categories);
	$smarty->assign('numActiveAuctions', $numActiveAuctions);
	$smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
	$smarty->assign('topTenRankingUsers', $topTenRankingUsers);
	$smarty->assign('auctions', $mostPopularAuctions);
	$smarty->assign('mostRecentAuction', $mostRecentAuction);
	$smarty->display('auctions/list_best_auctions.tpl');
?>