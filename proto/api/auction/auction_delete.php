<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auctionId = trim(strip_tags($_POST['auctionId']));
if(!is_numeric($auctionId)) {
  echo "Error 400 Bad Request: Invalid auction id!";
  return;
}

if(!isOwner($userId, $auctionId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

try {
  deleteAuction($auctionId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error removing auction!";
  return;
}

echo 'Success: Auction successfully removed.';