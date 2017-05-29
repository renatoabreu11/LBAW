<?php
include_once('../config/init.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

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

$auction = getAuction($auctionId);
$product = getAuctionProduct($auctionId);

try {
  $message = "Your auction " . $product['name'] . " is now open!<br>";
  notifyUser($auction['user_id'], $message, "Auction");
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => 'Open auction notification.'));
  return;
}

$watchlistUsers = getUsersWithActiveNotifications($auctionId);
foreach ($watchlistUsers as $user){
  if($user['user_id'] != $auction['user_id']){
    try {
      $message = "The auction " . $product['name'] . " is now open!<br>May the odds be ever in your favor! Good luck!";
      notifyUser($user['user_id'], $message, "Auction");
    } catch(PDOException $e) {
      $log->error($e->getMessage(), array('request' => 'Open auction notification.'));
      return;
    }
  }
}