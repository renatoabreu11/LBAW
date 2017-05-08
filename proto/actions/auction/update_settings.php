<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/users.php');

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user_id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['qa_section'] || !$_POST['notifications_enabled'] || !$_POST['auction_id']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$auctionId = $_POST['auction_id'];

if(!isOwner($userId, $auctionId)){
  header("Location: $BASE_URL");
  exit;
}

$auction = getAuction($auctionId);

if($auction['start_date'] > date("Y-m-d H:i:s")){
  $_SESSION['error_messages'][] = "The auction has already started. You can't update it anymore.";
  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
  exit;
}

$invalidInfo = false;
$notificationsEnabled = $_POST['notifications_enabled'];
if($notificationsEnabled != "No" && $notificationsEnabled != "Yes"){
  $_SESSION['field_errors']['notifications_enabled'] = 'Invalid notifications option';
  $invalidInfo = true;
}else{
  if($notificationsEnabled == "No")
    $notificationsEnabled = 'FALSE';
  else $notificationsEnabled = 'TRUE';
}

$qaSection = $_POST['qa_section'];
if($qaSection != "No" && $qaSection != "Yes"){
  $_SESSION['field_errors']['qa_section'] = 'Invalid Q&A option';
  $invalidInfo = true;
}else{
  if($qaSection == "No")
    $qaSection = 'FALSE';
  else $qaSection = 'TRUE';
}

if($invalidInfo){
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}else {
  if($qaSection !== $auction['questions_section']){
    try {
      updateAuctionQA($auctionId, $qaSection);
    } catch (PDOException $e) {
      $_SESSION['field_errors']['qa_section'] = 'Error updating the Q&A option.';
      header("Location:"  . $_SERVER['HTTP_REFERER']);
      exit;
    }
  }

  $watchlist = getWatchlistInfo($userId, $auctionId);
  if($notificationsEnabled !== $watchlist['notifications']){
    try {
      updateWatchlistNotifications($auctionId, $userId, $notificationsEnabled);
    } catch (PDOException $e) {
      $log->error($e->getMessage(), array('userId' => $userId, 'auctionId' => $auctionId, 'request' => 'Updating auction settings info.'));
      $_SESSION['field_errors']['notifications_enabled'] = 'Error updating the notifications option.';
      header("Location:"  . $_SERVER['HTTP_REFERER']);
      exit;
    }
  }

  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
}