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

if(!$_SESSION['user_id']){
  $id = $_SESSION['user_id'];
  $token = $_SESSION['token'];
  $notifications = getActiveNotifications($id);
  $smarty->assign("userId", $id);
  $smarty->assign("token", $token);
  $smarty->assign('notifications', $notifications);
}else if(!$_SESSION['admin_id']){
  $id = $_SESSION['admin_id'];
  $token = $_SESSION['token'];
  $smarty->assign("adminId", $id);
  $smarty->assign("token", $token);
}

$smarty->assign('categories', $categories);
$smarty->assign('numActiveAuctions', $numActiveAuctions);
$smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
$smarty->assign('topTenRankingUsers', $topTenRankingUsers);
$smarty->assign('auctions', $mostPopularAuctions);
$smarty->assign('mostRecentAuction', $mostRecentAuction);
$smarty->display('auctions/list_best_auctions.tpl');