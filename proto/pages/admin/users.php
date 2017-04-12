<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

$smarty->assign("admin_section", "users");
$smarty->display('admin/admin_page.tpl');