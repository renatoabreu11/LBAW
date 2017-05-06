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

    $originalName = $_POST['originalName'];
    $imageId = $_POST['key'];
    $productId = $_POST['productId'];
    $image = getImage($imageId);
    if(!$productId || !$imageId || !$originalName){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid request attributes!");
      echo json_encode($reply);
      return;
    }

    if(!validProductImage($imageId, $productId, $originalName)){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid image specification!");
      echo json_encode($reply);
      return;
    }

    try {
      deleteProductPicture($imageId);
    } catch(PDOException $e) {
      $reply = array('error' =>  "Error 500 Internal server: Error deleting the picture!");
      echo json_encode($reply);
      return;
    }

    $path = realpath($BASE_DIR . 'images/auctions/' . $image['filename']);
    if(is_writable($path)){
      unlink($path);
    }

    echo json_encode([]);

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