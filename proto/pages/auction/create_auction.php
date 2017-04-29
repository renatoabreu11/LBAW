<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];
$token = $_SESSION['token'];

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

$smarty->assign("userId", $id);
$smarty->assign("token", $token);
$smarty->assign("categories", $categories);
$smarty->display('auction/create_auction.tpl');