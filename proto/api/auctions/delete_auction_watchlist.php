<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auctions.php");

if(!$_POST['token'] || !$_POST['userId'] || !$_POST['auctionId']) {
  echo "Error 403 Forbidden: You don't have permissions to make this request. Fields missing.";
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

try {
  removeAuctionFromWatchlist($userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => "Remove auction from watchlist."));
  echo "Error 500 Internal Server: Error removing auction from watchlist.";
  return;
}

echo "Success: Auction removed successfully from watchlist.";