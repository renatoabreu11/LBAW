<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auction.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validUser($username, $id)){
    $smarty->display('common/404.tpl');
    return;
}

if(!isset($_GET['id'])){
    $smarty->display('common/404.tpl');
    return;
}

$auction_id = $_GET['id'];

if(!isOwner($id, $auction_id)){
    $smarty->display('common/404.tpl');
    return;
}

$product = getAuctionProduct($auction_id);

if($username && $id){
    $notifications = getActiveNotifications($_SESSION['user_id']);
    $smarty->assign('notifications', $notifications);
}

$smarty->assign("product", $product);
$smarty->assign("token", $_SESSION['token']);
$smarty->display('auction/auction_gallery.tpl');