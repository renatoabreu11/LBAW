<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');

use Intervention\Image\ImageManager;

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['id']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$userId = $_POST['id'];
if(!is_numeric($userId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid user!";
  echo json_encode($reply);
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
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting user.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "User successfully removed!";
echo json_encode($reply);