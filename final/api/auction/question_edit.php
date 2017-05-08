<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$questionId = trim(strip_tags($_POST['questionId']));
if(!is_numeric($questionId)) {
  echo "Error 400 Bad Request: Invalid question id!";
  return;
}

if(!isQuestionCreator($questionId, $userId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if(!$_POST['comment']) {
  echo "Error 400 Bad Request: All fields are mandatory!";
  return;
}

$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  echo "Error 400 Bad Request: The field length exceeds the maximum!";
  return;
}

$question = getQuestion($questionId);
$elapsedQuestionSeconds = strtotime(date('Y-m-d H:i')) - strtotime($question['date']);
$editTimeAllowed = 900;     //900 = 15 minutes * 60 seconds.
if($elapsedQuestionSeconds > $editTimeAllowed){
  echo "Error 403 Forbidden: The time to edit the question has expired.";
  return;
}

try {
  editQuestion($questionId, $comment);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Edit question.'));
  echo "Error 500 Internal Server: Couldn't edit question!";
  return;
}

echo 'Success: Question successfully edited.';