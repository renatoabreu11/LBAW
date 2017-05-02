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

if (!$_POST['notifications']){
  echo 'Error 400 Bad Request: Invalid notifications id\'s!';
  return;
}

$notifications = $_POST['notifications'];

foreach ($notifications as $notification){
  if(!is_numeric($notification)){
    echo "Error 400 Bad Request: Invalid notification id.";
  }else{
    try {
      updateNotification($notification);
    } catch (PDOException $e) {
      echo "Error 500 Internal Server: Error marking notification as read.";
    }
  }
}

echo "Success: All notifications are marked as read!";