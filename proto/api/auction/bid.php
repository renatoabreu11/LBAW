<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if(!$_POST['amount'] || !$_POST['user-id'] || !$_POST['token'] || !$_POST['auction-id']) {
  echo "Error: invalid bid request.";
  return;
}

if (!hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error: you don't have permissions to make this request.";
  return;
}

$logged_user_id = $_SESSION['user_id'];
$user_id = trim(strip_tags($_POST['user-id']));
if($logged_user_id != $user_id) {
  echo "Error: invalid user.";
  return;
}

$amount = trim(strip_tags($_POST['amount']));
if(!is_numeric($amount)) {
  echo "Error: amount is not numeric.";
  return;
}

$auction_id = trim(strim_tags($_POST['auction-id']));
if(!is_numeric($auction_id)) {
  echo "Error: invalid auction id.";
  return;
}

try {
  $ret = bid($amount, $user_id, $auction_id);
} catch(PDOException $e) {
  echo $e->getMessage();
  echo "Error: couldn't bid on the auction.";
  return;
}

echo $ret;