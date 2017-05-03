<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$adminId = $_POST['adminId'];
$userId = $_POST['userId'];
if(!$adminId) {
  $loggedAdminId = $_SESSION['admin_id'];
  if($loggedAdminId != $adminId) {
    echo "Error 403 Forbidden: You don't have permissions to make this request.";
    return;
  }
}else if(!$userId) {
  $loggedUserId = $_SESSION['user_id'];
  if($loggedUserId != $userId) {
    echo "Error 403 Forbidden: You don't have permissions to make this request.";
    return;
  }
}else {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if(!$_POST['answerId']) {
  echo 'Error 400 Bad Request: Invalid answer id!';
  return;
}

$answerId = $_POST['answerId'];
if(!is_numeric($answerId)) {
  echo 'Error 400 Bad Request: Invalid answer id!';
  return;
}

if($userId && !isAnswerCreator($answerId, $userId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

try {
  deleteAnswer($answerId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error deleting answer.";
  return;
}

echo "Success: Answer deleted successfully.";