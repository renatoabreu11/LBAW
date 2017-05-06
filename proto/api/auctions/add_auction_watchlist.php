<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auctions.php");

if(!$_POST['token'] || !$_POST['userId'] || !$_POST['auctionId'] || !$_POST['notifications']) {
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

$notifications = trim(strip_tags($_POST['notifications']));
if($notifications == "Yes")
  $notifications = true;
else if($notifications == "No")
  $notifications = false;
else {
  echo "Error 400 Bad Request: Notifications value is not the expected.";
  return;
}

try {
  addAuctionToWatchlist($userId, $auctionId, $notifications);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Add auction to watchlist.'));
  echo "Error 500 Internal Server: Error adding auction to watchlist.";
  return;
}

echo "Success: Auction added successfully to watchlist.";