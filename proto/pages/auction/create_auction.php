<?php

include_once ('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

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

$smarty->display('auction/create_auction.tpl');