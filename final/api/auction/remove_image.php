<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

$reply = array();
if (!empty($_POST['token']) || !$_SESSION['token']) {
  if (hash_equals($_SESSION['token'], $_POST['token'])) {
    $userId = $_POST['userId'];
    $loggedUserId = $_SESSION['user_id'];
    if($loggedUserId != $userId) {
      $reply = array('error' =>  "You don't have permissions to make this request.");
      echo json_encode($reply);
      return;
    }

    $originalName = $_POST['originalName'];
    $imageId = $_POST['key'];
    $productId = $_POST['productId'];
    $image = getImage($imageId);
    if(!$productId || !$imageId || !$originalName){
      $reply = array('error' =>  "Invalid request attributes!");
      echo json_encode($reply);
      return;
    }

    if(!validProductImage($imageId, $productId, $originalName)){
      $reply = array('error' =>  "Invalid image specification!");
      echo json_encode($reply);
      return;
    }

    try {
      deleteProductPicture($imageId);
    } catch(PDOException $e) {
      $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Delete image.'));
      $reply = array('error' =>  "Error deleting the picture!");
      echo json_encode($reply);
      return;
    }

    $path = realpath($BASE_DIR . 'images/auctions/' . $image['filename']);
    $thumbnailPath = realpath($BASE_DIR . 'images/auctions/thumbnails/' . $image['filename']);
    if(is_writable($path) && is_writable($thumbnailPath)){
      unlink($path);
      unlink($thumbnailPath);
    }

    echo json_encode([]);

  } else {
    $reply = array('error' =>  "You don't have permissions to make this request.");
    echo json_encode($reply);
    return;
  }
}else {
  $reply = array('error' =>  "You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}