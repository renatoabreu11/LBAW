<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/admins.php');

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

$amazonSearchIndices = array(
  'Apparel',
  'Appliances',
  'Automotive',
  'Baby',
  'Beauty',
  'Blended',
  'Books',
  'Classical',
  'DVD',
  'Electronics',
  'Grocery',
  'HealthPersonalCare',
  'HomeGarden',
  'HomeImprovement',
  'Jewelry',
  'KindleStore',
  'Kitchen',
  'Lighting',
  'Marketplace',
  'MP3Downloads',
  'Music',
  'MusicTracks',
  'MusicalInstruments',
  'OfficeProducts',
  'OutdoorLiving',
  'Outlet',
  'PetSupplies',
  'PCHardware',
  'Shoes',
  'Software',
  'SoftwareVideoGames',
  'SportingGoods',
  'Tools','Toys',
  'VHS',
  'Video',
  'VideoGames',
  'Watches'
);

$notifications = getActiveNotifications($id);
$categories = getCategories();
$auctionTypes = getAuctionTypes();

$smarty->assign("searchIndex", "Books");
$smarty->assign("module", "Auction");
$smarty->assign('auctionTypes', $auctionTypes);
$smarty->assign('notifications', $notifications);
$smarty->assign("categories", $categories);
$smarty->assign("searchIndices", $amazonSearchIndices);
$smarty->display('auction/create_auction.tpl');