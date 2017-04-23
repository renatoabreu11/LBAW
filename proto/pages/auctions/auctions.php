<?php
	include_once ('../../config/init.php');
	include_once ($BASE_DIR . 'database/admins.php');
	include_once ($BASE_DIR . 'database/auctions.php');
	include_once ($BASE_DIR . 'database/users.php');

	if (!$_GET['search']) {
	    $_SESSION['error_messages'][] = "Field of search not specified!";
	    header("Location:"  . $_SERVER['HTTP_REFERER']);
	    exit;
	}

	$search = trim(strip_tags($_GET['search']));
	$auctions = searchAuctions($search);
	$categories = getCategories();

	if($_SESSION['username'] && $_SESSION['user_id']){
		$notifications = getActiveNotifications($_SESSION['user_id']);
        $smarty->assign('notifications', $notifications);
	}

	$smarty->assign('search', $search);
	$smarty->assign('auctions', $auctions);
	$smarty->assign('categories', $categories);
	$smarty->display('auctions/auctions.tpl');
?>
