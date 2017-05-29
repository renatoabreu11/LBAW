<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/admins.php');
include_once ($BASE_DIR . 'database/auctions.php');
include_once ($BASE_DIR . 'database/users.php');

if (!$_GET['search'] && !$_GET['category']) {
  $_SESSION['error_messages'][] = "Field of search not specified!";
  header("Location: auctions.php?category=all");
  exit;
}

$categories = getCategories();
$auctions = null;
$textSearch = null;

if ($_GET['search'] && !$_GET['category']) {
  $textSearch = trim(strip_tags($_GET['search']));
  $auctions = searchAuctions($textSearch);
} else if (!$_GET['search'] && $_GET['category']) {
  $category = trim(strip_tags($_GET['category']));
  $auctions = searchAuctionsByCategory($category);
}else if ($_GET['search'] && $_GET['category']) {
  $textSearch = trim(strip_tags($_GET['search']));
  $category = trim(strip_tags($_GET['category']));
  $auctions = searchAuctionsByCategoryAndName($textSearch, $category);
}

foreach ($auctions as &$auction) {
  if ($auction['image'] == null)
    $auction['image'] = 'default.jpeg';
  $auction['end_date_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
  $auction['start_date_readable'] = date('d F Y, H:i:s', strtotime($auction['start_date']));
}

if($_SESSION['user_id']){
  $id = $_SESSION['user_id'];
  $notifications = getActiveNotifications($id);
  foreach ($notifications as &$n){
    $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
  }
  $smarty->assign('notifications', $notifications);
}

if($_GET['category']){
  $categorySearch = $_GET['category'];
  $smarty->assign('categorySearch', $categorySearch);
}

$items = 8;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign("module", "Auctions");
$smarty->assign('nrPages', $nr_pages);
$smarty->assign('textSearch', $textSearch);
$smarty->assign('auctions', $auctions);
$smarty->assign('categories', $categories);
$smarty->display('auctions/auctions.tpl');