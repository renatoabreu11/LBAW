<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

if(!$_POST['amount'] || !$_POST['auctionId']) {
  $reply = array('message' => "Error 400 Bad Request: All fields are mandatory!");
  echo json_encode($reply);
  return;
}

$amount = round($_POST['amount'], 2);
if(!is_numeric($amount)) {
  $reply = array('message' => "Error 400 Bad Request: Invalid amount!");
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  $reply = array('message' => "Error 400 Bad Request: Invalid auction id!");
  echo json_encode($reply);
  return;
}

if(isOwner($userId, $auctionId)){
  $reply = array('message' => "Error 403 Forbidden: The auction's seller cannot bid on his own auction!");
  echo json_encode($reply);
  return;
}

try {
  $ret = bid($amount, $userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Bid on auction.'));
  $reply = array('message' => "Error 500 Internal Server: Error creating the bid." );
  echo json_encode($reply);
  return;
}

$getRecentBidders = getRecentBidders($auctionId);
$smarty->assign("recentBidders", $getRecentBidders);
$biddersDiv = $smarty->fetch('auction/list_bidders.tpl');

$reply = array(
  'message' => $ret,
  'date' => date('d-m-Y H:m'),
  'biddersDiv' => $biddersDiv);

echo json_encode($reply);