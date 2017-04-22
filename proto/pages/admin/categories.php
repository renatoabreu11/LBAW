<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['admin_username'];
$id = $_SESSION['admin_id'];

if(!$username || !$id){
    $smarty->display('common/error.tpl');
    return;
}

if(!validAdmin($username, $id)){
    $smarty->display('common/error.tpl');
    return;
}

$categories = getCategories();

$smarty->assign("categories", $categories);
$smarty->assign("admin_section", "categories");
$smarty->display('admin/admin_page.tpl');