<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedUserId = $_SESSION['user_id'];
$user_id = $_POST['userId'];
if($loggedUserId != $user_id) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['id']){
  echo 'Error 400 Bad Request: Invalid notification id!';
  return;
}

$notificationId = $_POST['id'];

if(!is_numeric($notificationId)){
  echo 'Error 400 Bad Request: Invalid feedback id.';
  return;
}

try {
  deleteNotification($notificationId);
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error deleting notification.";
  return;
}

echo "Success 200 OK: Notification successfully removed!";