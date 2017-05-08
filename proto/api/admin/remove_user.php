<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');

use Intervention\Image\ImageManager;

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['id']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$userId = $_POST['id'];
if(!is_numeric($userId)){
  echo 'Error 400 Bad Request: Invalid user id.';
  return;
}

$auctions = getUserAuctions($userId);
$manager = new ImageManager();

foreach ($auctions as $auction){
  $images = getProductImages($auction['product_id']);
  foreach ($images as $image){
    $path = realpath($BASE_DIR . 'images/auctions/' . $image['filename']);
    $thumbnailPath = realpath($BASE_DIR . 'images/auctions/thumbnails' . $image['filename']);
    if(is_writable($path) && is_writable($thumbnailPath)){
      unlink($path);
      unlink($thumbnailPath);
    }
  }
}

$user = getUser($userId);
$profilePic = $user['profile_pic'];
if($profilePic != 'default.png'){
  $profilePath = realpath($BASE_DIR . 'images/users/' . $profilePic);
  if(is_writable($profilePath)){
    unlink($profilePath);
  }
}

try {
  deleteUser($userId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove user.'));
  echo "Error 500 Internal Server: Error deleting user.";
  return;
}

echo "Success: User successfully removed!";