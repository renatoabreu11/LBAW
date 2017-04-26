<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/admins.php');

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

if($username && $id){
    $notifications = getActiveNotifications($_SESSION['user_id']);
    $smarty->assign('notifications', $notifications);
}

$categories = getCategories();

$smarty->assign("token", $_SESSION['token']);
$smarty->assign("categories", $categories);
$smarty->display('auction/create_auction.tpl');