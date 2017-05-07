<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if(!$_POST['id'] || !$_POST['productId'] || !$_POST['token'] || !$_POST['adminId']) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

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

if (!$_POST['id']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$auctionId = $_POST['id'];
if(!is_numeric($auctionId)){
  echo 'Error 400 Bad Request: Invalid auction id.';
  return;
}

$productId = $_POST['productId'];
if(!is_numeric($productId)){
  echo 'Error 400 Bad Request: Invalid auction id.';
  return;
}

try {
  deleteAuction($auctionId, $productId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove auction.'));
  echo "Error 500 Internal Server: Error deleting auction.";
  return;
}

echo "Success: Auction successfully removed!";