<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');
include_once($BASE_DIR . 'database/auction.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
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

if(!$_POST['rating'] || !$_POST['message'] || !$_POST['bidId']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid parameters.";
  echo json_encode($reply);
  return;
}

$rating = trim(strip_tags($_POST['rating']));
$message = trim(strip_tags($_POST['message']));
$bidId = $_POST['bidId'];

if(!is_numeric($rating)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid rating input.";
  echo json_encode($reply);
  return;
}

if(strlen($message) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The message length exceeds the maximum (512 characters)";
  echo json_encode($reply);
  return;
}

$bid = getBid($bidId);
if($bid != null){
  $bidder = $bid['user_id'];
  $auctionId = $bid['auction_id'];
  $winner = getWinningUser($auctionId);
  if(!($winner['id'] == $bidder)){
    $reply['response'] = "Error 403 Forbidden";
    $reply['message'] = "You don't have permissions to make this request. You can only review auctions that you have won.";
    echo json_encode($reply);
    return;
  }
}else {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid bid " . $bidId;
  echo json_encode($reply);
  return;
}

try {
  insertReview($rating, $message, $bidId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Review auction.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the review.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Review created with success.";
echo json_encode($reply);