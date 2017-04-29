<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user_id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
}

if(!$_POST['qa_section'] || !$_POST['notifications_enabled'] || !$_POST['auction_id']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$auctionId = $_POST['auction_id'];

if(!isOwner($userId, $auctionId)){
  header("Location: $BASE_URL");
  return;
}