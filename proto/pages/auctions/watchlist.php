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

$page = $_GET['page'];

if (empty($page) || is_numeric($page) == FALSE) {
    $page = 1;
}else {
    $page = $_GET['page'];
}

$items = 2;
$offset = ($page * $items) - $items;

$auctions = getPageWatchlistAuctions($id, $items, $offset);
$notifications = getActiveNotifications($id);
$nr_pages = round(countWatchlistAuctions($id) / $items);

$smarty->assign('currPage', $page);
$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('auctions', $auctions);
$smarty->display('auctions/watchlist.tpl');