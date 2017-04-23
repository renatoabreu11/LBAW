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

$feedback = getFeedback();

$smarty->assign("feedback", $feedback);
$smarty->assign("admin_section", "feedback");
$smarty->display('admin/admin_page.tpl');