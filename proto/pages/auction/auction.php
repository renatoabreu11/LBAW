<?php
include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/auction.php');
include_once ($BASE_DIR . 'database/users.php');

$auction_id = $_GET["id"];
$auction = getAuction($auction_id);
$product = getAuctionProduct($auction_id);
$nrReviews = getNrReviews($auction["user_id"]);

$smarty->assign("product", $product);
$smarty->assign("auction", $auction);
$smarty->display('auction/auction.tpl');