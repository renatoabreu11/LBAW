<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");
include_once($BASE_DIR . "database/users.php");

if(!$_POST['auction-id'] || !$_POST['token'] || !$_POST['user-id'] || !$_POST['comment']) {
  $reply = array('error' => 'Error: some fields are not set.');
  echo json_encode($reply);
  return;
}

if (!hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply = array('error' => 'Error: tokens are not the same.');
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = trim(strip_tags($_POST['user-id']));
if($loggedUserId != $userId) {
  $reply = array('error' => 'Error: user id is not the same.');
  echo json_encode($reply);
  return;
}

$auctionId = trim(strip_tags($_POST['auction-id']));
if(!is_numeric($auctionId)) {
  $reply = array('error' => 'Error: auction id is not numeric.');
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);

try {
  createQuestion($comment, $loggedUserId, $auctionId);
} catch(PDOException $e) {
  $reply = array('error' => 'Error: couldn\'t insert question.');
  echo json_encode($reply);
  return;
}

try {
  $user = getUser($userId);
} catch(PDOException $e) {
  $reply = array('error' => 'Error: couldn\'t get user.');
  echo json_encode($reply);
  return;
}

$reply = array('comment' => $comment, 'user-id' => $loggedUserId, 'username' => $user['username'], 'profile_pic' => $user['profile_pic'], 'date' => date('Y-m-d H:i:s'));
echo json_encode($reply);