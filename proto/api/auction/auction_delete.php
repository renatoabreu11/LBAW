<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId)) {
  echo "Error 400 Bad Request: Invalid auction id!";
  return;
}

if(!isOwner($userId, $auctionId)){
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$auction = getAuction($auctionId);

// Verificar se já começou, se sim, não eliminar
if($auction['start_date'] < date("Y-m-d H:i:s")){
  $_SESSION['error_messages'][] = "The auction has already started. You can't update it anymore.";
  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
  exit;
}

// eliminar as fotos do leilão -> usar intervention

try {
  deleteAuction($auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Delete auction.'));
  echo "Error 500 Internal Server: Error removing auction!";
  return;
}

echo 'Success: Auction successfully removed.';