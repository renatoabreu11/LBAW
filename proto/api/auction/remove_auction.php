<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['auctionId'] || !$_POST['productId'] || !$_POST['userId'] || !$_POST['token']) {
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
$productId = $_POST['productId'];

try {
    $imagesFilename = deleteAuction($auctionId, $productId);
} catch(PDOException $e) {
    echo "Error 500 Internal Server: Couldn't delete auction." . $e->getMessage();
    return;
}

foreach($imagesFilename as $filename) {
  echo ($filename['filename']);
  $path = realpath($BASE_DIR . 'images/auctions/' . $filename['filename']);
  if(is_writable($path))
    unlink($path);

  $path = realpath($BASE_DIR . 'images/auctions/thumbnails/' . $filename['filename']);
  if(is_writable($path))
    unlink($path);
}

echo "Success: Auction deleted successfully.";