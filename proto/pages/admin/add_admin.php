<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$smarty->assign("admin_section", "add_admin");
$smarty->display('admin/admin_page.tpl');