<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

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

if(!$_POST['rating'] || !$_POST['message'] || !$_POST['bidId']) {
  echo 'Error 400 Bad Request: Invalid parameters!';
  return;
}

$rating = trim(strip_tags($_POST['rating']));
$message = trim(strip_tags($_POST['message']));
$bidId = $_POST['bidId'];

if(!is_numeric($rating)|| !is_numeric($message)) {
  echo 'Error 400 Bad Request: Invalid parameters!';
  return;
}

if(strlen($message) > 512){
  echo "Error 400 Bad Request: The field length exceeds the maximum!";
  return;
}

try {
  insertReview($rating, $message, $bidId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Review auction.'));
  echo "Error 500 Internal Server: Error creating the review.";
  return;
}

echo "Success: Review posted.";