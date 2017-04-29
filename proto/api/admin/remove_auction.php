<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');

if (!$_POST['id']){
  echo 'Invalid auction id!';
  return;
}

$auction_id = $_POST['id'];

try {
  deleteAuction($auction_id);
} catch (PDOException $e) {
  echo $e->getMessage();
  return;
}

echo "Auction deleted!";