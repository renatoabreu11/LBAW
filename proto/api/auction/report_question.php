<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$questionId = $_POST['questionId'];
if(!is_numeric($questionId)) {
  echo "Error 400 Bad Request: Invalid question id!";
  return;
}

if(isQuestionCreator($questionId, $userId)){
  echo "Error 403 Forbidden: You can't report your own question.";
  return;
}

$comment = strip_tags($_POST['comment']);
if(!$comment){
  echo "Error 400 Bad Request: All fields are required!";
  return;
}

if(strlen($comment) > 512){
  echo "Error 400 Bad Request: The field length exceeds the maximum!";
  return;
}

try {
  createQuestionReport($questionId, $comment);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create question report.'));
  echo "Error 500 Internal Server: Error creating the question report.";
  return;
}

echo "Success: The report was delivered with success and the administrators will look into it. Thank you.";