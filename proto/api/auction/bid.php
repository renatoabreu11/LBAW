<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/auction.php');

if (!$_GET['amount'] || !$_GET['bidder_id'] || !$_GET['auction_id']) {
  echo 'All fields are mandatory!';
  exit;
}

$amount = $_GET['amount'];
$bidder_id = $_GET['bidder_id'];
$auction_id = $_GET['auction_id'];

echo $amount . " " . $bidder_id . " " . $auction_id;

$ret = bid($amount, $bidder_id, $auction_id);
echo $ret;
