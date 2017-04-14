<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

$auctionsIDs = getAuctionsInfo();
$auctions = array();

foreach ($auctionsIDs as $auctionArr){
    $product_name = getProductName($auctionArr["product_id"])["name"];
    $seller = getUser($auctionArr["user_id"])["name"];
}

//$smarty->assign("auctions", $auctions);
//$smarty->assign("admin_section", "auctions");
//$smarty->display('admin/admin_page.tpl');