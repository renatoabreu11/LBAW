<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['auctionId'] || !$_POST['userId'] || !$_POST['token']) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

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

$auctionId = $_POST['auctionId'];

try {
    deleteAuctionAdmin($auctionId);
} catch(PDOException $e) {
    echo "Error 500 Internal Server: Couldn't delete auction.";
    return;
}

echo "Success: Auction deleted successfully.";