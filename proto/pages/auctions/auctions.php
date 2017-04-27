<?php
	include_once ('../../config/init.php');
	include_once ($BASE_DIR . 'database/admins.php');
	include_once ($BASE_DIR . 'database/auctions.php');
	include_once ($BASE_DIR . 'database/users.php');

	if (!$_GET['search'] && !$_GET['category'] && !$_GET['page']) {
	    $_SESSION['error_messages'][] = "Field of search not specified!";
	    header("Location:"  . $_SERVER['HTTP_REFERER']);
	    exit;
	}

	$auctions = null;
	$textSearch = null;

	if ($_GET['search'] && !$_GET['category']) {
		$textSearch = trim(strip_tags($_GET['search']));
		$auctions = searchAuctions($textSearch);
	}
	else if (!$_GET['search'] && $_GET['category']) {
		$category = trim(strip_tags($_GET['category']));
		$auctions = searchAuctionsByCategory($category);
	}
	else if ($_GET['search'] && !$_GET['category']) {
		$textSearch = trim(strip_tags($_GET['search']));
		$category = trim(strip_tags($_GET['category']));
		$auctions = searchAuctionsByCategoryAndName($textSearch, $category);
	}
	
	$page = trim(strip_tags($_GET['page']));
	$categories = getCategories();

	if($_SESSION['username'] && $_SESSION['user_id']) {
		$notifications = getActiveNotifications($_SESSION['user_id']);
        $smarty->assign('notifications', $notifications);
	}

	$smarty->assign('search', $textSearch);
	$smarty->assign('auctions', $auctions);
	$smarty->assign('categories', $categories);
	$smarty->display('auctions/auctions.tpl');
?>
