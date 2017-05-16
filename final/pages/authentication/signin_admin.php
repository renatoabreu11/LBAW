<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$smarty->assign("module", "Auth");
$smarty->display('authentication/signin_admin.tpl');