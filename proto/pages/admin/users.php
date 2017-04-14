<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

$users = getAllUsers();
$nrUsers = count($users);
$usersPerPage = 10;
$nrPages = $nrUsers / $usersPerPage;

$smarty->assign("users", $users);
$smarty->assign("nrUsers", $nrUsers);
$smarty->assign("nrPages", $nrPages);
$smarty->assign("usersPerPage", $usersPerPage);
$smarty->assign("admin_section", "users");
$smarty->display('admin/admin_page.tpl');