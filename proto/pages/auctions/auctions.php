<?php
	include_once ('../../config/init.php');
	include_once ($BASE_DIR . 'database/admins.php');

	$categories = getCategories();

	$smarty->assign('categories', $categories);
	$smarty->display('auctions/auctions.tpl');
?>
