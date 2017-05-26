<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');

$reply = array();
if (!is_numeric($_GET['fromPrice']) || !is_numeric($_GET['toPrice'])) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The price range values must be valid numbers.";
  echo json_encode($reply);
  return;
}

if (!isset($_GET['name']) || !$_GET['category']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
  echo json_encode($reply);
  return;
}

$nameAuction = trim(strip_tags($_GET["name"]));
if ( !preg_match ("/^[a-zA-Z0-9\s]*$/", $nameAuction)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction name characters.";
  echo json_encode($reply);
  return;
}

$category = trim(strip_tags($_GET['category']));
$fromPrice = (int)$_GET['fromPrice'];
$toPrice = (int)$_GET['toPrice'];

if ($toPrice < $fromPrice) {
  $fromPrice = $toPrice + $fromPrice;
  $toPrice = $fromPrice - $toPrice;
  $fromPrice = $fromPrice - $toPrice;
}

$getEndDate = strtr($_GET['endDate'], '/', '-');
$fromDate = date("Y-m-d H:i");
$toDate = date("Y-m-d H:i", strtotime($getEndDate));
if(!$fromDate || !$toDate){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid remaining time date.";
  echo json_encode($reply);
  return;
}

if($fromDate > $toDate){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid remaining time interval.";
  echo json_encode($reply);
  return;
}

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
  $auction['end_date_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
  $auction['start_date_readable'] = date('d F Y, H:i:s', strtotime($auction['start_date']));
}

$items = 8;
$nr_pages = ceil(count($auctions) / $items);

$smarty->assign('auctions', $auctions);
$list = $smarty->fetch('auctions/list.tpl');
$listThumbnail = $smarty->fetch('auctions/list_thumbnail.tpl');
$dataToRetrieve = array('response' => "Success 200",
  'message' => 'Auctions retrieved with success.',
  'list' => $list,
  'listThumbnail' => $listThumbnail,
  'nr_pages' => $nr_pages);
echo json_encode($dataToRetrieve);