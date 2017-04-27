<?php
	include_once ('../../config/init.php');
	include_once ($BASE_DIR . 'database/admins.php');
	include_once ($BASE_DIR . 'database/auctions.php');
	include_once ($BASE_DIR . 'database/users.php');

	if (!$_GET['search'] && !$_GET['category']) {
	    $_SESSION['error_messages'][] = "Fields of search category not specified!";
	    header("Location:"  . $_SERVER['HTTP_REFERER']);
	    exit;
	}

	if ($_SESSION['username'] && $_SESSION['user_id']) {
		$notifications = getActiveNotifications($_SESSION['user_id']);
        $smarty->assign('notifications', $notifications);
	}
	$categories = getCategories();

	$auctions = null;
	$textSearch = null;

	$curr_url_without_page = null;

	if ($_GET['search'] && !$_GET['category']) {
		$textSearch = trim(strip_tags($_GET['search']));
		$auctions = searchAuctions($textSearch);
		$curr_url_without_page = $BASE_URL . "pages/auctions/auctions.php?search=" . $textSearch;
	}
	else if (!$_GET['search'] && $_GET['category']) {
		$category = trim(strip_tags($_GET['category']));
		$auctions = searchAuctionsByCategory($category);
		$curr_url_without_page = $BASE_URL . "pages/auctions/auctions.php?category=" . $category;
	}
	else if ($_GET['search'] && !$_GET['category']) {
		$textSearch = trim(strip_tags($_GET['search']));
		$category = trim(strip_tags($_GET['category']));
		$auctions = searchAuctionsByCategoryAndName($textSearch, $category);
		$curr_url_without_page = $BASE_URL . "pages/auctions/auctions.php?category=" . $category . "&search=" . $textSearch;
	}
	
	
	$page = $_GET['page'];
	if (empty($page) || is_numeric($page) == FALSE) {
	    $page = 1;
	}else {
	    $page = $_GET['page'];
	}
	
	$items = 5;
	$offset = ($page * $items) - $items;
	$nr_pages = ceil(count($auctions) / $items);
	$auctions = array_slice($auctions, $offset, $items);

	$smarty->assign('curr_url_without_page', $curr_url_without_page);
	$smarty->assign('curr_page', $page);
	$smarty->assign('nr_pages', $nr_pages);
	$smarty->assign('search', $textSearch);
	$smarty->assign('auctions', $auctions);
	$smarty->assign('categories', $categories);
	$smarty->display('auctions/auctions.tpl');
?>
