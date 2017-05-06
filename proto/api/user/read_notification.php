<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/users.php');

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

if (!$_POST['notification']){
  echo 'Error 400 Bad Request: Invalid notifications id!';
  return;
}

$notificationId = $_POST['notification'];

if(!is_numeric($notificationId)){
  echo 'Error 400 Bad Request: Invalid notification id!';
  return;
}

try {
  updateNotification($notificationId);
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error marking notification as read.";
}

echo "Success: Notification read.";