<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['amount'] || !$_POST['auctionId']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
  echo json_encode($reply);
  return;
}

$amount = round($_POST['amount'], 2);
if(!is_numeric($amount)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid amount!";
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction.";
  echo json_encode($reply);
  return;
}

if(isOwner($userId, $auctionId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "The auction's seller cannot bid on his own auction!";
  echo json_encode($reply);
  return;
}

if(getAuctionState($auctionId) != 'Open'){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You cannot bid on an auction that is not open!";
  echo json_encode($reply);
  return;
}

try {
  $ret = bid($amount, $userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Bid on auction.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the bid.";
  echo json_encode($reply);
  return;
}

$getRecentBidders = getRecentBidders($auctionId);
$smarty->assign("recentBidders", $getRecentBidders);
$biddersDiv = $smarty->fetch('auction/list_bidders.tpl');

$message;
if($ret == "Error 403 Forbidden")
  $message = "You currently have the highest bid.";
else if($ret == "Success 201 Created")
  $message = "Your bet was correctly recorded.";
else if($ret == "Success 203")
  $message = "Insufficient funds. You don't have the necessary amount to place a new bid.";

$reply = array(
  'response' => $ret,
  'message' => $message,
  'date' => date('d F Y, H:i'),
  'biddersDiv' => $biddersDiv);
echo json_encode($reply);