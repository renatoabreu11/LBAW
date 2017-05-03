<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user-id'];
if($loggedUserId != $userId) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

if(!$_POST['amount'] || !$_POST['auction-id']) {
  $reply = array('message' => "Error 400 Bad Request: All fields are mandatory!");
  echo json_encode($reply);
  return;
}

$amount = $_POST['amount'];
if(!is_numeric($amount)) {
  $reply = array('message' => "Error 400 Bad Request: Invalid amount!");
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auction-id'];
if(!is_numeric($auctionId)) {
  $reply = array('message' => "Error 400 Bad Request: Invalid auction id!");
  echo json_encode($reply);
  return;
}

try {
  $ret = bid($amount, $userId, $auctionId);
} catch(PDOException $e) {
  $reply = array('message' => "Error 500 Internal Server: Error creating the bid.");
  echo json_encode($reply);
  return;
}

$reply = array('message' => $ret, 'date' => date('d-m-Y H:m'));
echo json_encode($reply);