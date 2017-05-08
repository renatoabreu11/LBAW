<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auctions.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['token'] || !$_SESSION['token'] || !$_POST['userId'] || !$_POST['auctionId']) {
  echo "Error 400 Bad Request: Invalid request. Some fields are missing.";
  return;
}

if (!hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  echo "Error 400 Bad Request: Invalid auction id.";
  return;
}

if(isOwner($userId, $auctionId)){
  echo "Error 403 Forbidden: You cannot remove your auction from the watchlist!";
  return;
}

try {
  removeAuctionFromWatchlist($userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => "Remove auction from watchlist."));
  echo "Error 500 Internal Server: Error removing auction from watchlist.";
  return;
}

echo "Success: Auction removed successfully from watchlist.";