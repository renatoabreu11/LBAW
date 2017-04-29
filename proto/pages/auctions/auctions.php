<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/admins.php');
include_once ($BASE_DIR . 'database/auctions.php');
include_once ($BASE_DIR . 'database/users.php');

if (!$_GET['search'] && !$_GET['category']) {
  $_SESSION['error_messages'][] = "Fields of search category not specified!";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$categories = getCategories();
$auctions = null;
$textSearch = null;

if ($_GET['search'] && !$_GET['category']) {
  $textSearch = trim(strip_tags($_GET['search']));
  $auctions = searchAuctions($textSearch);
}
else if (!$_GET['search'] && $_GET['category']) {
  $category = trim(strip_tags($_GET['category']));
  $auctions = searchAuctionsByCategory($category);
}
else if ($_GET['search'] && !$_GET['category']) {
  $textSearch = trim(strip_tags($_GET['search']));
  $category = trim(strip_tags($_GET['category']));
  $auctions = searchAuctionsByCategoryAndName($textSearch, $category);
}

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

$smarty->assign('textSearch', $textSearch);
$smarty->assign('auctions', $auctions);
$smarty->assign('categories', $categories);
$smarty->display('auctions/auctions.tpl');