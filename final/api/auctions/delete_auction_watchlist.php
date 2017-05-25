<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auctions.php");
include_once($BASE_DIR . "database/auction.php");

$reply = array();
if (!$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
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

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction.";
  echo json_encode($reply);
  return;
}

if(isOwner($userId, $auctionId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You cannot remove your auction from the watchlist!";
  echo json_encode($reply);
  return;
}

try {
  removeAuctionFromWatchlist($userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => "Remove auction from watchlist."));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error removing auction from watchlist.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Auction removed successfully from watchlist.";
echo json_encode($reply);