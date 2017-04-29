<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/auctions.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validUser($username, $id)) {
    $smarty->display('common/404.tpl');
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

$page_auctions = getPageWatchlistAuctions($id, $items, $offset);
$notifications = getActiveNotifications($id);

$nr_pages = round(countWatchlistAuctions($id) / $items);

$smarty->assign('currPage', $page);
$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('pageAuctions', $page_auctions);
$smarty->display('auctions/watchlist.tpl');