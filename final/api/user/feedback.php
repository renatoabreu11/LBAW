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

if(!$_POST['feedback']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$feedback = trim(strip_tags($_POST["feedback"]));
if ( strlen($feedback) > 256){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid feedback length!";
  echo json_encode($reply);
  return;
}

try {
  createFeedback($userId, $feedback);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create feedback.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the feedback message.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Thank you for your collaboration! With your help we can improve even more our website.";
echo json_encode($reply);