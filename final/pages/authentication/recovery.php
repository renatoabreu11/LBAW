<?php

include_once ('../../config/init.php');
$smarty->assign("module", "Auth");
$smarty->display('authentication/recovery.tpl');