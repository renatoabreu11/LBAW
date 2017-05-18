<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');

if (!is_numeric($_GET['fromPrice']) || !is_numeric($_GET['toPrice'])
  || !is_numeric($_GET['fromTimeRem']) || !is_numeric($_GET['toTimeRem'])) {
  echo json_encode("Error 400 Bad Request: Invalid values. All of the values must be numbers.");
  return;
}

if (!isset($_GET['name']) || !$_GET['category']){
  echo json_encode('Error 400 Bad Request: All fields are mandatory!');
  return;
}

$nameAuction = trim(strip_tags($_GET["name"]));
if ( !preg_match ("/^[a-zA-Z0-9\s]*$/", $nameAuction)){
  echo json_encode('Error 400 Bad Request: Invalid auction name characters');
  return;
}

$category = trim(strip_tags($_GET['category']));

$fromPrice = (int)$_GET['fromPrice'];
$toPrice = (int)$_GET['toPrice'];

$fromTimeRem = (int)$_GET['fromTimeRem'];
$toTimeRem = (int)$_GET['toTimeRem'];

$fromDate = new DateTime();
$fromDate->add(new DateInterval('PT'. $fromTimeRem .'S'));
$fromDateTimeStamp = $fromDate->getTimestamp();

$toDate = new DateTime();
$toDate->add(new DateInterval('PT'. $toTimeRem .'S'));
$toDateTimeStamp = $toDate->getTimestamp();

if ($toPrice < $fromPrice) {
  $fromPrice = $toPrice + $fromPrice;
  $toPrice = $fromPrice - $toPrice;
  $fromPrice = $fromPrice - $toPrice;
}

if ($toDateTimeStamp < $fromDateTimeStamp) {
  $fromDateTimeStamp = $toDateTimeStamp + $fromDateTimeStamp;
  $toDateTimeStamp = $fromDateTimeStamp - $toDateTimeStamp;
  $fromDateTimeStamp = $fromDateTimeStamp - $toDate;
}

$fromDate = date('Y-m-d H:i:s', $fromDateTimeStamp);
$toDate = date('Y-m-d H:i:s', $toDateTimeStamp);

$auctions = null;
if (strcmp($nameAuction, "") == 0) {
  if (strcmp($category, "All") == 0) {
    $auctions = searchAuctionsByDatePrice($fromDate, $toDate, $fromPrice, $toPrice);
  }
  else {
    $auctions = searchAuctionsByDatePriceCategory($fromDate, $toDate, $fromPrice, $toPrice, $category);
  }
}
else {
  if (strcmp($category, "All") == 0) {
    $auctions = searchAuctionsByDatePriceText($fromDate, $toDate, $fromPrice, $toPrice, $nameAuction);
  }
  else {
    $auctions = searchAuctionsByDatePriceTextCategory($fromDate, $toDate, $fromPrice, $toPrice, $nameAuction, $category);
  }
}

foreach ($auctions as &$auction) {
  if ($auction['image'] == null)
    $auction['image'] = 'default.jpeg';
}

$items = 8;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign('auctions', $auctions);
$list = $smarty->fetch('auctions/list.tpl');
$listThumbnail = $smarty->fetch('auctions/list_thumbnail.tpl');
$dataToRetrieve = array('list' => $list, 'listThumbnail' => $listThumbnail, 'nr_pages' => $nr_pages);
echo json_encode($dataToRetrieve);
