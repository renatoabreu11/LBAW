<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if(!$_POST['question-id'] || !$_POST['comment'] || !$_POST['user-id'] || !$_POST['token']) {
  echo 'error: some fields are not set.';
  return;
}

if (!hash_equals($_SESSION['token'], $_POST['token'])) {
  echo 'error: tokens are not the same.';
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = trim(strip_tags($_POST['user-id']));
if($loggedUserId != $userId) {
  echo 'error: user id is not the same.';
  return;
}

$questionId = trim(strip_tags($_POST['question-id']));
if(!is_numeric($questionId)) {
  echo 'error: question id is not a number.';
  return;
}

$comment = $_POST['comment'];

try {
  editQuestion($questionId, $comment);
} catch(PDOException $e) {
  echo 'error: couldn\'t edit question';
  return;
}

echo 'success: question successfully edited.';