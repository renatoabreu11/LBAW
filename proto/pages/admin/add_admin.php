<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');


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

$smarty->assign("adminSection", "addAdmin");
$smarty->display('admin/admin_page.tpl');