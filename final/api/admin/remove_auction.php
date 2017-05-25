<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['id'];
if(!is_numeric($auctionId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction id.";
  echo json_encode($reply);
  return;
}
$auction = getAuction($auctionId);

try {
  deleteAuction($auctionId, $auction['product_id']);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove auction.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting auction.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Auction successfully removed!";
echo json_encode($reply);