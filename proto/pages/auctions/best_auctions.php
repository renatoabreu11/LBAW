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
	
	$now  = strtotime(date('Y-m-d H:i:s'));
	foreach ($mostPopularAuctions as &$auction) {

		$endDate = strtotime($auction['end_date']);
		$differenceInSeconds = $endDate - $now;
		
		$diffHours = intval($differenceInSeconds /(60 * 60));
		$diffMinutes = intval(($differenceInSeconds-$diffHours*60*60)/60);
		$diffSeconds = intval($differenceInSeconds-$diffHours*60*60-$diffMinutes*60);

		$diffHours = (string)$diffHours;
		$diffMinutes = (string)$diffMinutes;
		$diffSeconds = (string)$diffSeconds;
		
		if (strlen($diffHours) == 1) $diffHours = '0'.$diffHours;
		if (strlen($diffMinutes) == 1) $diffMinutes = '0'.$diffMinutes;
		if (strlen($diffSeconds) == 1) $diffSeconds = '0'.$diffSeconds;

		$timeRemaining = $diffHours."h:".$diffMinutes."m:".$diffSeconds."s";

		$auction['time_remain'] = $timeRemaining;
	}

	$smarty->assign('categories', $categories);
	$smarty->assign('numActiveAuctions', $numActiveAuctions);
	$smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
	$smarty->assign('topTenRankingUsers', $topTenRankingUsers);
	$smarty->assign('mostPopularAuctions', $mostPopularAuctions);
	$smarty->display('auctions/list_best_auctions.tpl');
?>