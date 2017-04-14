<?php
	include_once ('../../config/init.php');
	include_once ($BASE_DIR . 'database/admins.php');
	include_once ($BASE_DIR . 'database/auctions.php');

	if (!$_GET['search']) {
	    $_SESSION['error_messages'][] = "Field of search not specified!";
	    header("Location: $BASE_URL" . 'pages/authentication/signup.php');
	    exit;
	}

	$search = trim(strip_tags($_GET['search']));
	$auctions = searchAuctions($search);
	$categories = getCategories();

	$smarty->assign('search', $search);
	$smarty->assign('auctions', $auctions);
	$smarty->assign('categories', $categories);
	$smarty->display('auctions/auctions.tpl');
?>
