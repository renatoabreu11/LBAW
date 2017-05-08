<?php
include_once('../config/init.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

$auctionId = $_GET['auctionId'];
if(!is_numeric($auctionId)){
  return;
}

try {
  closeAuction($auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => 'Close auction.'));
  return;
}

$winner = getWinningUser($auctionId);
$auction = getAuction($auctionId);
$product = getAuctionProduct($auctionId);
if($winner){
  try {
    $message = "You've won the auction " . $product['name'] . " with a bid of " . $auction['curr_bid'] . "€. Congratulations!";
    notifyUser($winner['id'], $message, "Win");
  } catch (PDOException $e) {
    $log->error($e->getMessage(), array('request' => 'Auction win notification.'));
    return;
  }
}

try {
  $message = "Your auction " . $product['name'] . " is now closed.<br>";
  if($winner){
    $message .= "The user " . $winner['username'] . " had the highest bid (" . $auction['curr_bid'] . "€) and won the auction.<br>";
    $message .= "The money will be shortly transferred to your account.";
    try {
      addCredit($auction['user_id'], $auction['curr_bid']);
    } catch (PDOException $e) {
      $log->error($e->getMessage(), array('request' => 'Add seller credit'));
      return;
    }
  }else{
    $message .= "No one placed a bid in your auction :(. Better luck next time!";
  }
  notifyUser($auction['user_id'], $message, "Auction");
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('request' => 'Auction closed notification.'));
  return;
}