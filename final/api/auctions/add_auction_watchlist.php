<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auctions.php");

$reply = array();
if (!$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['auctionId'] || !$_POST['notifications']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction.";
  echo json_encode($reply);
  return;
}

$notifications = trim(strip_tags($_POST['notifications']));
if($notifications == "Yes")
  $notifications = 1;
else if($notifications == "No")
  $notifications = 0;
else {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Notifications value is not the expected.";
  echo json_encode($reply);
  return;
}

try {
  addAuctionToWatchlist($userId, $auctionId, $notifications);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Add auction to watchlist.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error adding auction to watchlist.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Auction added successfully to watchlist.";
echo json_encode($reply);