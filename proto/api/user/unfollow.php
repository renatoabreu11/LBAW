<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$unfollowedUserId = $_POST['unfollowedUserId'];
if(!$unfollowedUserId || !is_numeric($unfollowedUserId)) {
  echo 'Error 400 Bad Request: Invalid unfollowed user id!';
  return;
}

if($unfollowedUserId == $userId){
  echo 'Error 400 Bad Request: You can\'t unfollow yourself!';
  return;
}

try {
  unfollowUser($userId, $unfollowedUserId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Unfollow user.'));
  echo "Error 500 Internal Server: Error unfollowing user.";
  return;
}

echo "Success: Your are no longer following the user.";