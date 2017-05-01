<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if(!$_POST['feedback']) {
  echo "Error 400 Bad Request: All fields are mandatory!";
  return;
}

$feedback = trim(strip_tags($_POST["feedback"]));

if ( strlen($feedback) > 256){
  echo '"Error 400 Bad Request: Invalid feedback length.';
  return;
}

try {
  createFeedback($userId, $feedback);
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error creating the feedback message.";
  return;
}

echo "Success: Thank you for your collaboration! With your help we can improve even more our website.";