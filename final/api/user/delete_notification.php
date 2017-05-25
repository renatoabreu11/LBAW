<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

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

$notificationId = $_POST['id'];
if (!$notificationId || !is_numeric($notificationId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid notification.";
  echo json_encode($reply);
  return;
}

try {
  deleteNotification($notificationId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Remove notification'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting notification.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Notification successfully removed!";
echo json_encode($reply);