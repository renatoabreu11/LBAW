<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

$reply = array();
$token = $_POST['token'];
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

$productId = $_POST['productId'];
if(!is_numeric($productId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid product.";
  echo json_encode($reply);
  return;
}

$auctionId = getAuctionIdFromProduct($productId);
if(!isOwner($userId, $auctionId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$images;
try {
  $images = getProductImages($productId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Get product images.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error retrieving the product images.";
  echo json_encode($reply);
  return;
}

$p1 = $p2 = $p3 = [];
$i = 0;
foreach ($images as  $image){
  $key = $image['id'];
  $extra = array();
  $extra['userId'] = $userId;
  $extra['productId'] = $productId;
  $extra['token'] = $token;
  $extra['originalName'] = $image['original_name'];
  $url = $BASE_URL . 'api/auction/remove_image.php';
  $p1[$i] = $BASE_URL . "images/auctions/" . $image['filename'];
  $p2[$i] = ['caption' => $image['description'], 'url' => $url, 'key' => $key, 'extra' => $extra];
  $p3[$i] = ['{TAG_VALUE}' => $image['description'], '{TAG_CSS_NEW}' => 'hide', '{TAG_CSS_INIT}' => ''];
  $i++;
}

echo json_encode([
  'initialPreview' => $p1,
  'initialPreviewConfig' => $p2,
  'initialPreviewThumbTags' => $p3,
  'response' => "Success 200",
  'message' => "Product images retrieved with success!"
]);