<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

use Intervention\Image\ImageManager;

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request. Generated token is different.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request. User id's are different.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['realName'] || !$_POST['smallBio'] || !$_POST['email']) {
  $_SESSION['error_messages'][] = "Your real name, small biography and email are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$realName = trim(strip_tags($_POST['realName']));
$smallBio = trim(strip_tags($_POST['smallBio']));
$cityId = trim(strip_tags($_POST['cityId']));
$email = trim(strip_tags($_POST['email']));
$phone = trim(strip_tags($_POST['phone']));
$fullBio = trim(strip_tags($_POST['fullBio']));

$invalidChars = false;

if(!preg_match("/^[a-zA-Z\s]+$/", $realName)) {
  $_SESSION['field_errors']['realName'] = 'Invalid name characters.';
  $invalidChars = true;
}

if(strlen($realName) > 64){
  $_SESSION['field_errors']['realName'] = 'Invalid name length. The maximum length is 64.';
  $invalidChars = true;
}

if(strlen($smallBio) > 255){
  $_SESSION['field_errors']['smallBio'] = 'Invalid small bio length.';
  $invalidChars = true;
}

if(strlen($fullBio) > 512){
  $_SESSION['field_errors']['fullBio'] = 'Invalid full bio length.';
  $invalidChars = true;
}

if($phone) {
  if(!is_numeric($phone)) {
    $_SESSION['field_errors']['phone'] = 'Invalid phone characters';
    $invalidChars = true;
  }
}

$isCityNull = true;
if($cityId) {
  $isCityNull = false;
  if(!(is_numeric($cityId))) {
    $_SESSION['field_errors']['cityId'] = 'Invalid city id.';
    $invalidChars = true;
  }
}

if($invalidChars) {
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . 'pages/user/user_edit.php?id=' . $userId);
  exit;
}

try {
  updateUserDetails($userId, $realName, $smallBio, $email, $phone, $fullBio);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Update user details.'));
  $_SESSION['error_messages'][] = "Error updating your personal details.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

if(!($isCityNull)) {
  try {
    updateUserLocation($userId, $cityId);
  } catch(PDOException $e) {
    $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Update user location.'));
    $_SESSION['error_messages'][] = "Error updating your location.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }
}

// Updates profile picture.
$picture = $_FILES['picture'];
if($picture['size'] > 0) {
  $extension = end(explode(".", $picture['name']));
  $picturePath = $BASE_DIR . "images/users/" . $userId . "." . $extension;

  $oldPicture = getProfilePic($userId);
  $oldExtension = end(explode(".", $oldPicture));
  if($oldPicture != 'default.png' && $oldExtension != $extension) {
    $path = realpath($BASE_DIR . 'images/users/' . $oldPicture);
    if(is_writable($path))
      unlink($path);
  }

  // Resize the image.
  $manager = new ImageManager();
  $img = $manager->make($picturePath);
  $img->fit(156, 156);
  $img->save($picturePath);

  try {
    updateUserPicture($userId, $userId . "." . $extension);
  } catch(PDOException $e) {
    $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Update user info.'));
    $_SESSION['error_messages'][] = "Error updating your profile avatar. Please select another photo.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }
} else if($picture['name']) {
  $_SESSION['error_messages'][] = "Error updating your profile avatar. The image size is bigger than the allowed.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$_SESSION['success_messages'][] = 'Personal information updated with success.';
header("Location: $BASE_URL" . 'pages/user/user.php?id=' . $userId);