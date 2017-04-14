<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

$users = getAllUsers();

$smarty->assign("users", $users);
$smarty->assign("admin_section", "users");
$smarty->display('admin/admin_page.tpl');