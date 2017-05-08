<?php
include_once('../config/init.php');
include_once($BASE_DIR .'database/auction.php');

$auctionId = $_GET['auctionId'];
if(!is_numeric($auctionId)){
  return;
}

try {
  openAuction($auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => 'Open auction.'));
  return;
}