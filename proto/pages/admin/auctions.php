<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');

$smarty->assign("admin_section", "auctions");
$smarty->display('admin/admin_page.tpl');