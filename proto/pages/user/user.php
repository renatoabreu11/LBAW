<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/users.php');

    if(!$_GET['id']) {
        $_SESSION['error_messages'][] = "Undefined id";
        header("Location: $BASE_URL");
        exit;
    }

    $userId = trim(strip_tags($_GET['id']));
    $loggedUserId = $_SESSION['user_id'];
    
    if(!preg_match("/[0-9]/", $userId)) {
        $_SESSION['error_messages'][] = "id has invalid characters";
        header("Location: $BASE_URL");
        exit;
    }

    $user = getUser($userId);
    $location = getCityAndCountry($userId);
    $isFollowing = getIsFollowing($loggedUserId, $userId);        // handle if user not logged in.
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

    if($userId == $loggedUserId)
        $reviewsPosted = getWonReviews($userId);

    $smarty->assign('loggedUserId', $loggedUserId);
    $smarty->assign('user', $user);
    $smarty->assign('location', $location);
    $smarty->assign('isFollowing', $isFollowing);
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

    if($userId == $loggedUserId)
        $smarty->assign('reviewsPosted', $reviewsPosted);

    $smarty->display('user/user.tpl');
?>
