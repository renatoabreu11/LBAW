<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['answer-id'] || !$_POST['token'] || !$_POST['user-id'] || !$_POST['comment']) {
  echo "Error: some fields are not set.";
  return;
}

if (!hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error: tokens are not the same.";
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = trim(strip_tags($_POST['user-id']));
if($loggedUserId != $userId) {
  echo "Error: user id is not the same.";
  return;
}

$answerId = trim(strip_tags($_POST['answer-id']));
if(!is_numeric($answerId)) {
  echo "Error: answer id is not numeric.";
  return;
}

$comment = strip_tags($_POST['comment']);

try {
  createAnswerReport($answerId, $comment);
} catch(PDOException $e) {
  echo $e->getMessage();
  echo "Error: couldn't create a new answer report.";
  return;
}

echo "success: answer report successfully created.";