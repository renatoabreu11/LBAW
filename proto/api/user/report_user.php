<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/user.php");

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

$reportedUserId = $_POST['userId'];
if(!is_numeric($userId)) {
  echo "Error 400 Bad Request: Invalid user id!";
  return;
}

if($reportedUserId == $userId){
  echo "Error 400 Bad Request: You can't report yourself!";
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
  createUserReport($userId, $comment);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error creating the user report.";
  return;
}

echo "Success: User report successfully created.";