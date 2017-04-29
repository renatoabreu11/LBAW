<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

if(!$_POST['user-id'] || !$_POST['real-name'] || !$_POST['small-bio'] || !$_POST['email']) {
  $_SESSION['error_messages'][] = "Your real name, small biography and email are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = trim(strip_tags($_POST['user-id']));

if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "id doesn't match.";
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

var_dump($_POST);
$invalidChars = false;

if(!preg_match("/^[a-zA-Z\s]+$/", $realName)) {
  $_SESSION['field_errors']['real_name'] = 'Invalid name characters';
  $invalidChars = true;
}

$isCityNull = false;
if($cityId) {
  if($cityId == "null")
    $isCityNull = true;
  if(!(is_numeric($cityId))) {
    $_SESSION['field_errors']['city-id'] = 'Invalid city id';
    $invalidChars = true;
  }
}

if(!preg_match('/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/', $email)) {
  $_SESSION['field_errors']['email'] = 'Invalid email format';
  $invalidChars = true;
  echo 'mail';
}

if($invalidChars) {
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . 'pages/user/user_edit.php?id=' . $userId);
  exit;
}

try {
  updateUserDetails($userId, $realName, $smallBio, $email, $phone, $fullBio);
} catch(PDOException $e) {
  $_SESSION['error_messages'][] = "error: can't update user details.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

if(!($isCityNull)) {
  try {
    updateUserLocation($userId, $cityId);
  } catch(PDOException $e) {
    $_SESSION['error_messages'][] = "error: can't update user location.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }
}

// Updates profile picture.
$picture = $_FILES['picture'];
if($picture['size'] > 0) {
  $extension = end(explode(".", $picture['name']));
  try {
    updateUserPicture($userId, $userId . "." . $extension);
  } catch(PDOException $e) {
    echo $e;
    $_SESSION['error_messages'][] = "error: can't update user profile avatar.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }

  $picturePath = $BASE_DIR . "images/users/" . $userId . "." . $extension;
  if(!move_uploaded_file($picture['tmp_name'], $picturePath)) {
    $_SESSION['error_messages'][] = "error: can't move user profile avatar.";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }
} else if($picture['name']) {
  $_SESSION['error_messages'][] = "error: image is bigger than the allowed.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$_SESSION['success_messages'][] = 'Update successful';
header("Location: $BASE_URL" . 'pages/user/user.php?id=' . $userId);