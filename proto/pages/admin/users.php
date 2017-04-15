<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

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