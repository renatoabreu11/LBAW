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

$questionId = trim(strip_tags($_POST['questionId']));
if(!is_numeric($questionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid question.";
  echo json_encode($reply);
  return;
}

if(!isQuestionCreator($questionId, $userId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['comment']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The question length exceeds the maximum number of characters (512).";
  echo json_encode($reply);
  return;
}

$question = getQuestion($questionId);
$elapsedQuestionSeconds = strtotime(date('Y-m-d H:i')) - strtotime($question['date']);
$editTimeAllowed = 900;     //900 = 15 minutes * 60 seconds.
if($elapsedQuestionSeconds > $editTimeAllowed){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "The time to edit the question has expired.";
  echo json_encode($reply);
  return;
}

try {
  editQuestion($questionId, $comment);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Edit question.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Couldn't edit the question!";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Question successfully edited.";
echo json_encode($reply);