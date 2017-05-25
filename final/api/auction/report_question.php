<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

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

$questionId = $_POST['questionId'];
if(!is_numeric($questionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid question.";
  echo json_encode($reply);
  return;
}

if(isQuestionCreator($questionId, $userId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You can't report your own question.";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(!$comment){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
  echo json_encode($reply);
  return;
}

if(strlen($comment) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The report length exceeds the maximum number of characters (512).";
  echo json_encode($reply);
  return;
}

try {
  createQuestionReport($questionId, $comment);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create question report.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the question report.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "The report was delivered with success and the administrators will look into it. Thank you.";
echo json_encode($reply);