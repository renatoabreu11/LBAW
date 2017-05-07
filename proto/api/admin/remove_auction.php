<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auctionId = $_POST['id'];
if(!is_numeric($auctionId)){
  echo 'Error 400 Bad Request: Invalid auction id.';
  return;
}
$auction = getAuction($auctionId);

try {
  deleteAuction($auctionId, $auction['product_id']);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove auction.'));
  echo "Error 500 Internal Server: Error deleting auction.";
  return;
}

echo "Success: Auction successfully removed!";