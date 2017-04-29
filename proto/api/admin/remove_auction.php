<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');

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

try {
  deleteAuction($auctionId);
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error deleting auction.";
  return;
}

echo "Success 200 OK: Auction successfully removed!";