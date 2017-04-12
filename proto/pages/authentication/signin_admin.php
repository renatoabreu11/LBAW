<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$smarty->display('authentication/signin_admin.tpl');