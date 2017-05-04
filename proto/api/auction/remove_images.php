<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!empty($_POST['token'])) {
  if (hash_equals($_SESSION['token'], $_POST['token'])) {
    $userId = $_POST['userId'];
    $loggedUserId = $_SESSION['user_id'];
    if($loggedUserId != $userId) {
      $reply = array('error' =>  "Error 403 Forbidden: You don't have permissions to make this request.");
      echo json_encode($reply);
      return;
    }

    $productId = $_POST['productId'];
    $auctionId = getAuctionIdFromProduct($productId);
    if(!$productId){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid product id!");
      echo json_encode($reply);
      return;
    }

    $images = $_FILES['input24'];
    $nrImages = count($images['name']);
    $captions = $_POST['captions'];
    print_r($_FILES);
  } else {
    $reply = array('error' =>  "Error 403 Forbidden: You don't have permissions to make this request.");
    echo json_encode($reply);
    return;
  }
}else {
  $reply = array('error' =>  "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}