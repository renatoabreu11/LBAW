<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$categories = getCategories();

$smarty->assign("categories", $categories);
$smarty->assign("admin_section", "categories");
$smarty->display('admin/admin_page.tpl');