<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/users.php');

    if(!$_GET['id']) {
        die('lacks id');
    }

    $userId = $_GET['id'];

    $user = getUser($userId);
    $location = getCityAndCountry($userId);
    $totalAuctions = getNumTotalAuctions($userId);
    $activeAuctions = getActiveAuctions($userId);
    $reviews = getReviews($userId);
    $wins = getWins($userId);
    $followingUsers = getFollowingUsers($userId);

    // Recent Activity.
    $lastReviews = getLastReviews($userId);
    $lastBids = getLastBids($userId);
    $lastFollowing = getLastFollows($userId);
    $lastWins = getLastWins($userId);
    $lastQuestion = getLastQuestions($userId);
    $lastWatchlistAuctions = getLastWatchlistAuctions($userId);

    $smarty->assign('user', $user);
    $smarty->assign('location', $location);
    $smarty->assign('totalAuctions', $totalAuctions);
    $smarty->assign('activeAuctionsa', $activeAuctions);
    $smarty->assign('reviews', $reviews);
    $smarty->assign('wins', $wins);
    $smarty->assign('followingUsers', $followingUsers);

    $smarty->assign('lastReviews', $lastReviews);
    $smarty->assign('lastBids', $lastBids);
    $smarty->assign('lastFollowing', $lastFollowing);
    $smarty->assign('lastWins', $lastWins);
    $smarty->assign('lastQuestion', $lastQuestion);
    $smarty->assign('lastWatchlistAuctions', $lastWatchlistAuctions);

    $smarty->display('user/user.tpl');
?>