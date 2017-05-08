<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

use Intervention\Image\ImageManager;

if (!empty($_POST['token']) || !$_SESSION['token']) {
  if (hash_equals($_SESSION['token'], $_POST['token'])) {
    $token = $_SESSION['token'];
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
    if($nrImages > 10 || $nrImages < 1){
      $reply = array('error' =>  "Error 400 Bad Request: Invalid number of images!");
      echo json_encode($reply);
      return;
    }

    $productImages = getProductImages($productId);
    if(count($productImages) >= 10){
      $reply = array('error' =>  "Error 400 Bad Request: You can't upload more images. The maximum number of images was achieved!");
      echo json_encode($reply);
      return;
    }

    if(count($productImages) + $nrImages >= 10){
      $reply = array('error' =>  "Error 400 Bad Request: You can't upload so many images. The maximum number of images per product is 10!");
      echo json_encode($reply);
      return;
    }

    $captionsStr = $_POST['captions'];
    $captionsArr = explode(',', $captionsStr);
    if(count($captionsArr) != $nrImages){
      $reply = array('error' =>  "Error 400 Bad Request: Every picture must have a caption.");
      echo json_encode($reply);
      return;
    }

    foreach ($captionsArr as $caption){
      if($caption == ""){
        $reply = array('error' =>  "Error 400 Bad Request: Every picture must have a caption.");
        echo json_encode($reply);
        return;
      }else if(strlen($caption) > 128){
        $reply = array('error' =>  "Error 400 Bad Request: Every picture must have a caption with a maximum length of 128.");
        echo json_encode($reply);
        return;
      }
    }

    $names = $images['name'];
    $types = $images['type'];
    $tmp_names = $images['tmp_name'];
    $errors = $images['error'];
    $sizes = $images['size'];

    $i = 0;
    foreach($sizes as $size){
      if($size > 5000000){
        $reply = array('error' =>  "Error file " . $sizes[$i] . ": The maximum size of each image is 5MB.");
        echo json_encode($reply);
        return;
      }
      $i++;
    }

    $currentImagesNames = getProductImagesOriginalNames($productId);
    $i = 0;
    foreach ($names as $name){
      if(in_array($name, $currentImagesNames)){
        $reply = array('error' =>  "Error file " . $names[$i] . ": This image is already stored.");
        echo json_encode($reply);
        return;
      }
    }

    $reply;
    $p1 = $p2 = $p3 = [];
    $manager = new ImageManager();
    for($i = 0; $i < $nrImages; $i++) {
      if ($errors[$i]) {
        $reply['error'] .= "Picture " . $names[$i] . ": Invalid file!<br/>";
      }else {
        $imageId;
        $extension = end(explode("/", $types[$i]));
        $caption;
        try {
          $caption = trim(strip_tags($captionsArr[$i]));
          $imageId = addProductPicture($productId, $extension, $caption, $names[$i]);
        } catch(PDOException $e) {
          $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Upload auction image.'));
          $reply['error'] .= "Error 500 Internal Server: Error storing the association between the product and " . $names[$i] . ".<br/>";
        }

        $picturePath = $BASE_DIR . "images/auctions/" . $imageId . "." . $extension;
        $thumbnailPath = $BASE_DIR . "images/auctions/thumbnails/" . $imageId . "." . $extension;
        $img = $manager->make($tmp_names[$i]);
        $img->save($picturePath);
        $img->fit(460, 300);
        $img->save($thumbnailPath);
        $key = $imageId;
        $extra = array();
        $extra['userId'] = $userId;
        $extra['productId'] = $productId;
        $extra['token'] = $token;
        $extra['originalName'] = $names[$i];
        $url = $BASE_URL . 'api/auction/remove_image.php';
        $p1[$i] = $BASE_URL . "images/auctions/" . $imageId . "." . $extension;
        $p2[$i] = ['caption' => $caption, 'url' => $url, 'key' => $key, 'extra' => $extra];
        $p3[$i] = ['{TAG_VALUE}' => $caption, '{TAG_CSS_NEW}' => 'hide', '{TAG_CSS_INIT}' => ''];
      }
    }
    echo json_encode([
      'initialPreview' => $p1,
      'initialPreviewConfig' => $p2,
      'initialPreviewThumbTags' => $p3,
      'append' => true
    ]);

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