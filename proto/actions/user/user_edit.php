<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user-id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['real-name'] || !$_POST['small-bio'] || !$_POST['email']) {
  $_SESSION['error_messages'][] = "Your real name, small biography and email are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$realName = trim(strip_tags($_POST['real-name']));
$smallBio = trim(strip_tags($_POST['small-bio']));
$cityId = trim(strip_tags($_POST['city-id']));
$email = trim(strip_tags($_POST['email']));
$phone = trim(strip_tags($_POST['phone']));
$fullBio = trim(strip_tags($_POST['full-bio']));

$invalidChars = false;

if(!preg_match("/^[a-zA-Z\s]+$/", $realName)) {
  $_SESSION['field_errors']['real_name'] = 'Invalid name characters.';
  $invalidChars = true;
}

if($phone) {
  if(!preg_match("/[0-9]+/", $phone)) {
    $_SESSION['field_errors']['phone'] = 'Invalid numeric characters';
    $invalidChars = true;
  }
}

$isCityNull = false;
if($cityId) {
  if($cityId == "null")
    $isCityNull = true;
  if(!(is_numeric($cityId))) {
    $_SESSION['field_errors']['city-id'] = 'Invalid city id.';
    $invalidChars = true;
  }
}

if(!preg_match('/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/', $email)) {
  $_SESSION['field_errors']['email'] = 'Invalid email format';
  $invalidChars = true;
}

if($invalidChars) {
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . 'pages/user/user_edit.php?id=' . $userId);
  exit;
}

try {
  updateUserDetails($userId, $realName, $smallBio, $email, $phone, $fullBio);
} catch(PDOException $e) {
  $_SESSION['error_messages'][] = "Error updating your personal details.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

if(!($isCityNull)) {
  try {
    updateUserLocation($userId, $cityId);
  } catch(PDOException $e) {
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
  if(!move_uploaded_file($picture['tmp_name'], $picturePath)) {
    $_SESSION['error_messages'][] = "Error updating your profile avatar. Please select another photo.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }

  // carissimo evenilink, verifica se é preciso eliminar a foto antiga ou o move_uploaded_file faz o overwrite

  try {
    updateUserPicture($userId, $userId . "." . $extension);
  } catch(PDOException $e) {
    $path = realpath($BASE_URL . 'images/users/' . $userId . "." . $extension);
    if(is_writable($path)){
      unlink($path);
    }
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