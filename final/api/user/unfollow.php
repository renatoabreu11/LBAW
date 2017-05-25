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

$unfollowedUserId = $_POST['unfollowedUserId'];
if(!$unfollowedUserId || !is_numeric($unfollowedUserId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid unfollowed user!";
  echo json_encode($reply);
  return;
}

if($unfollowedUserId == $userId){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "You can't unfollow yourself!";
  echo json_encode($reply);
  return;
}

try {
  unfollowUser($userId, $unfollowedUserId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Unfollow user.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error unfollowing user.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "You are no longer following the user!";
echo json_encode($reply);