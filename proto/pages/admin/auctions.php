<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

$username = $_SESSION['admin_username'];
$id = $_SESSION['admin_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validAdmin($username, $id)){
    $smarty->display('common/404.tpl');
    return;
}

$auctionsIDs = getAllAuctions();
$auctions = array();

foreach ($auctionsIDs as $auctionArr){
    $product_name = getProductName($auctionArr["product_id"]);
    $seller = getUser($auctionArr["user_id"])["name"];
    $type = $auctionArr["type"];
    $start_date = $auctionArr["start_date"];
    $end_date = $auctionArr["end_date"];
    $auction = array(
        "id" => $auctionArr["id"],
        "product" => $product_name,
        "seller" => $seller,
        "type" => $type,
        "start_date" => $start_date,
        "end_date" => $end_date,
    );
    array_push($auctions, $auction);
}

$smarty->assign("auctions", $auctions);
$smarty->assign("admin_section", "auctions");
$smarty->display('admin/admin_page.tpl');