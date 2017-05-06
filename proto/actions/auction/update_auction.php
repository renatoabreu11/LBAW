<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user_id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['auction_type'] || !$_POST['base_price'] || !$_POST['quantity'] || !$_POST['start_date'] || !$_POST['end_date'] || !$_POST['auction_id']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$auctionId = $_POST['auction_id'];

if(!isOwner($userId, $auctionId)){
  header("Location: $BASE_URL");
  exit;
}

$auction = getAuction($auctionId);

if($auction['start_date'] < date("Y-m-d H:i:s")){
  $_SESSION['error_messages'][] = "The auction has already started. You can't update it anymore.";
  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
  exit;
}

$quantity = $_POST['quantity'];
if(!is_numeric($quantity) || $quantity > 25){
  $_SESSION['field_errors']['quantity'] = 'Invalid quantity.';
  $invalidInfo = true;
}

$auctionType = $_POST["auction_type"];
if ( !validAuctionType($auctionType)) {
  $invalidInfo = true;
  $_SESSION['field_errors']['auction_type'] = 'Invalid auction type.';
}

$basePrice = $_POST['base_price'];
if(!is_numeric($basePrice)){
  $_SESSION['field_errors']['base_price'] = 'Invalid base price.';
  $invalidInfo = true;
}

$postStartDate = strtr($_POST['start_date'], '/', '-');
$postEndDate = strtr($_POST['end_date'], '/', '-');
$startDate = date("Y-m-d H:i", strtotime($postStartDate));
$endDate = date("Y-m-d H:i", strtotime($postEndDate));
if($startDate > $endDate){
  $_SESSION['field_errors']['start_date'] = "The auction's starting date has to be smaller than the ending date.";
  $_SESSION['field_errors']['end_date'] = "The auction's ending date has to be after the starting date.";
  $invalidInfo = true;
}

if($startDate < date("Y-m-d H:i")){
  $_POST['start_date'] = date("d/m/Y H:i", strtotime('+1 hour'));
  $_SESSION['field_errors']['start_date'] = "The auction's starting date has to be after the current date.";
  $invalidInfo = true;
}

if($endDate < date("Y-m-d H:i")){
  $_POST['end_date'] = date("d/m/Y H:i", strtotime('+2 hour'));
  $_SESSION['field_errors']['end_date'] = "The auction's ending date has to be after the current date.";
  $invalidInfo = true;
}

if(!$startDate){
  $_SESSION['field_errors']['start_date'] = 'Invalid starting date.';
  $invalidInfo = true;
}

if(!$endDate){
  $_SESSION['field_errors']['end_date'] = 'Invalid ending date.';
  $invalidInfo = true;
}

if($invalidInfo){
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}else {
  try {
    updateAuction($auctionId, $basePrice, $quantity, $startDate, $endDate, $auctionType);
  } catch (PDOException $e) {
    $log->error($e->getMessage(), array('userId' => $userId, 'auctionId' => $auctionId, 'request' => 'Updating auction info.'));
    $_SESSION['error_messages'][] = 'Error updating the auction.';
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }

  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
}