<?php
include_once('../../config/init.php');
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

$users = getAllUsers();
$nrOfAuctionsByUser = array();

foreach ($users as $user){
    $nrAuctions = getNumTotalAuctions($user["id"]);
    array_push($nrOfAuctionsByUser, $nrAuctions);
}

$smarty->assign("auctions_user", $nrOfAuctionsByUser);
$smarty->assign("users", $users);
$smarty->assign("admin_section", "users");
$smarty->display('admin/admin_page.tpl');