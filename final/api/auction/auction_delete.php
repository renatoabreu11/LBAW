<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['auctionId'] || !$_POST['productId']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
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

$productId = $_POST['productId'];
if(!is_numeric($productId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction.";
  echo json_encode($reply);
  return;
}

if(!isOwner($userId, $auctionId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$auction = getAuction($auctionId);

if($auction['state'] != 'Created'){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "The auction has already started. You can't delete it.";
  echo json_encode($reply);
  return;
}

try {
  $imagesFilename = deleteAuction($auctionId, $productId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Remove auction.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Couldn't delete auction.";
  echo json_encode($reply);
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

$reply['response'] = "Success 200";
$reply['message'] = "Auction deleted successfully.";
echo json_encode($reply);