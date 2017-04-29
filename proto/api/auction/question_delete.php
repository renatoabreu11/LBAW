<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['question-id'] || !$_POST['user-id'] || !$_POST['token']) {
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

$questionId = trim(strip_tags($_POST['question-id']));
if(!is_numeric($questionId)) {
  echo "Error: invalid question id.";
  return;
}

try {
  deleteQuestion($questionId);
} catch(PDOException $e) {
  echo "Error: couldn't delete question.";
  return;
}

echo "success: question deleted successfully.";