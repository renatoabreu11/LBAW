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

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['id'] || !$_POST["message"]){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$userId = $_POST["id"];
$message = trim(strip_tags($_POST["message"]));

if(strlen($message) > 256){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid notification length!";
  echo json_encode($reply);
  return;
}

try {
  notifyUser($userId, $message, "Warning");
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Notify user.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error sending notification to the user.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "User notified.";
echo json_encode($reply);