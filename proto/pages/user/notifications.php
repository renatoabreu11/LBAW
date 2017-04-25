<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validUser($username, $id)) {
    $smarty->display('common/404.tpl');
    return;
}

$page = $_GET['page'];
echo $page;

if (empty($page) || is_numeric($page) == FALSE) {
    $page = 1;
}else {
    $page = $_GET['page'];
}

echo $page;