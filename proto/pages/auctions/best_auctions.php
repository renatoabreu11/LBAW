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
	
	$smarty->assign('categories', $categories);
	$smarty->assign('numActiveAuctions', $numActiveAuctions);
	$smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
	$smarty->assign('topTenRankingUsers', $topTenRankingUsers);
	$smarty->assign('auctions', $mostPopularAuctions);
	$smarty->display('auctions/list_best_auctions.tpl');
?>