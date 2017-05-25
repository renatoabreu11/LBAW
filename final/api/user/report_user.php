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

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$reportedUserId = $_POST['reportedUserId'];
if(!is_numeric($userId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid user.";
  echo json_encode($reply);
  return;
}

if($reportedUserId == $userId){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "You can't report yourself!";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(!$comment){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are required!";
  echo json_encode($reply);
  return;
}

if(strlen($comment) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The comment length text exceeds the maximum defined (512 characters)!";
  echo json_encode($reply);
  return;
}

try {
  createUserReport($reportedUserId, $comment);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Report user.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the user report.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "The report was delivered with success and the administrators will look into it. Thank you.";
echo json_encode($reply);