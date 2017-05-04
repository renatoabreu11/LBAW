<?php

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

$productId = $_POST['productId'];
if(!is_numeric($productId)) {
  echo "Error 400 Bad Request: Invalid product id!";
  return;
}

$auctionId = getAuctionIdFromProduct($productId);
if(!isOwner($userId, $auctionId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$images;
try {
  $images = getProductImages($productId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error retrieving product images!";
  return;
}