<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$followedUserId = $_POST['followedUserId'];
if(!$followedUserId || !is_numeric($followedUserId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid followed user!";
  echo json_encode($reply);
  return;
}

if($followedUserId == $userId){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "You can't follow yourself!";
  echo json_encode($reply);
  return;
}

try {
  followUser($userId, $followedUserId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Follow user.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error following user.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "You are now following the user!";
echo json_encode($reply);