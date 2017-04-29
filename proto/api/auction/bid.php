<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

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

if(!$_POST['amount'] || !$_POST['auctionId']) {
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$amount = $_POST['amount'];
if(!is_numeric($amount)) {
  echo 'Error 400 Bad Request: Invalid amount!';
  return;
}

$auctionId = $_POST['auction-id'];
if(!is_numeric($auctionId)) {
  echo 'Error 400 Bad Request: Invalid auction id!';
  return;
}

try {
    $ret = bid($amount, $userId, $auctionId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error creating the bid.";
  return;
}

echo $ret;