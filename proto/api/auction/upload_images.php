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
    if(!$productId){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid product id!");
      echo json_encode($reply);
      return;
    }

    $images = $_FILES['input24'];
    $nrImages = count($images['name']);
    $captions = $_POST['captions'];
    if($nrImages > 10 || $nrImages < 1){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid number of images!");
      echo json_encode($reply);
      return;
    }

    $captionsStr = $_POST['captions'];
    $captionsArr = explode(',', $captionsStr);
    $auctionId = getAuctionIdFromProduct($productId);
    $names = $images['name'];
    $types = $images['type'];
    $tmp_names = $images['tmp_name'];
    $errors = $images['error'];
    $sizes = $images['size'];
    $reply;
    for($i = 0; $i < $nrImages; $i++) {
      if ($errors[$i]) {
        $reply['Picture ' . $names[$i]] = "Error 400 Bad Request: Invalid file!";
      }else {
        $imageId = getNextImageId();
        $extension = end(explode("/", $types[$i]));
        try {
          $caption = trim(strip_tags($captionsArr[$i]));
          if(strlen($caption) > 128)
            $caption = "Product picture";
          addProductPicture($productId, $imageId . "." . $extension, $caption);
        } catch(PDOException $e) {
          $reply['Picture ' . $names[$i]] = "Error 500 Internal Server: Error storing image-product association.";
        }

        $picturePath = $BASE_DIR . "images/auctions/" . $imageId . "." . $extension;
        if (!move_uploaded_file($tmp_names[$i], $picturePath)) {
          $reply['Picture ' . $names[$i]] =  "Error 400 Bad Request: Error while storing the image!";
          deleteProductPicture($imageId);
        }
      }
    }
    echo json_encode($reply);
    return;

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