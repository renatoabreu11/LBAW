<?php
include_once('../config/init.php');
include_once($BASE_DIR .'database/auction.php');

$auctionId = $_GET['auctionId'];
closeAuction($auctionId);
?>