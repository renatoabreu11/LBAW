<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['auctionId'] || !$_POST['productId'] || !$_POST['userId'] || !$_POST['token']) {
  echo "Error 400 Bad Request: All fields are mandatory";
  return;
}

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
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
if(!is_numeric($auctionId)) {
  echo "Error 400 Bad Request: Invalid auction id!";
  return;
}

$productId = $_POST['productId'];
if(!is_numeric($productId)) {
  echo "Error 400 Bad Request: Invalid auction id!";
  return;
}

if(!isOwner($userId, $auctionId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auction = getAuction($auctionId);

if($auction['start_date'] < date("Y-m-d H:i:s")){
  echo "Error 400 Forbidden: The auction has already started. You can't delete it .";
  return;
}

try {
  $imagesFilename = deleteAuction($auctionId, $productId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Remove auction.'));
  echo "Error 500 Internal Server: Couldn't delete auction.";
  return;
}

foreach($imagesFilename as $filename) {
  $path = realpath($BASE_DIR . 'images/auctions/' . $filename['filename']);
  if(is_writable($path))
    unlink($path);

  $path = realpath($BASE_DIR . 'images/auctions/thumbnails/' . $filename['filename']);
  if(is_writable($path))
    unlink($path);
}

echo "Success: Auction deleted successfully.";