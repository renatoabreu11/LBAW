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

$answerId = trim(strip_tags($_POST['answerId']));
if(!is_numeric($answerId)) {
  echo "Error 400 Bad Request: Invalid answer id!";
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

$answer = getAnswer($answerId);
$elapsedQuestionSeconds = strtotime(date('Y-m-d H:m')) - strtotime($answer['date']);
$editTimeAllowed = 900;     //900 = 15 minutes * 60 seconds.
if($elapsedQuestionSeconds > $editTimeAllowed){
  echo "Error 403 Forbidden: The time to edit the answer has expired.";
  return;
}

try {
  editAnswer($answerId, $comment);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Couldn't edit answer!";
  return;
}

echo 'Success: Answer successfully edited.';