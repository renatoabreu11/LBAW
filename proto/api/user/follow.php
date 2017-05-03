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

$followedUserId = $_POST['followedUserId'];
if(!$followedUserId || !is_numeric($followedUserId)) {
  echo 'Error 400 Bad Request: Invalid followed user id!';
  return;
}

if($followedUserId == $userId){
  echo 'Error 400 Bad Request: You can\'t follow yourself!';
  return;
}

try {
  followUser($userId, $followedUserId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error following user.";
  return;
}

echo "Success: You have started to follow the user.";